Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030661AbaGRRkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:40:21 -0400
Received: from one.firstfloor.org ([193.170.194.197]:40905 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030515AbaGRRkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:40:20 -0400
Date: Fri, 18 Jul 2014 19:40:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 05/11] perf, tools: Add support for reading JSON event
 files
Message-ID: <20140718174018.GF18735@two.firstfloor.org>
References: <1405123165-22666-1-git-send-email-andi@firstfloor.org>
 <1405123165-22666-6-git-send-email-andi@firstfloor.org>
 <1405661382.17297.3.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405661382.17297.3.camel@concordia>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On powerpc our event names are always uppercase, it would be nice if the perf
> list output honoured that.
> 
> Can we instead just honour whatever case is in the input JSON ?

Intel events are upper case too. However perf is not into shouting
in general, so I chose to lower everything.

> 
> It looks like the event lookup is already case insensitive.

Yes if you want you can specify them upper case.

-Andi
