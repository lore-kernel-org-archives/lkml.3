Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbaEEX22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:28:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:52182 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbaEEX21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:28:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,992,1389772800"; 
   d="scan'208";a="427964201"
Date: Mon, 5 May 2014 16:28:21 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Yuchung Cheng <ycheng@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140505232821.GJ19657@tassilo.jf.intel.com>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <1399328773-6531-9-git-send-email-andi@firstfloor.org>
 <CAK6E8=cQ37-O=z6oxwhNZ+rog2VrLZQvjKW4sq+E97Yz-VNorQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK6E8=cQ37-O=z6oxwhNZ+rog2VrLZQvjKW4sq+E97Yz-VNorQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +config TCP_METRICS
> > +       bool "Report TCP metrics over netlink"
> > +       ---help---
> > +           Enable support in TCP to save host information between different
> > +          connections.
> Please add that "Certain TCP features such as active TCP Fast Open
> depends on this."

I added a select.

Also will fix the inaccurate help line.

-Andi
