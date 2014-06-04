Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaFDRDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:03:10 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:33781 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaFDRDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:03:08 -0400
Date: Wed, 4 Jun 2014 13:02:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        Kent Overstreet <kmo@daterainc.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu-refcount: fix usage of this_cpu_ops (was Re:
 hanging aio process)
Message-ID: <20140604170256.GK5004@htj.dyndns.org>
References: <alpine.LFD.2.11.1405201508450.1606@denkbrett>
 <CAOMFOmWfQ2naF+1BE0wSQXpBoyxV6MPm021hY77B4sDpZNZ-Dw@mail.gmail.com>
 <alpine.LFD.2.11.1405201945280.1631@denkbrett>
 <CAOMFOmUT-WGbV57qDafM-NJ+=s1OzX-2Q6G6hAh6EV8Vt9yBZw@mail.gmail.com>
 <alpine.LFD.2.11.1405210954110.1579@denkbrett>
 <alpine.LFD.2.11.1405211042350.1579@denkbrett>
 <CAOMFOmXXHBicH38onWgVAWhEXe2sE_RMiJXi=iMjJB15o7mOLQ@mail.gmail.com>
 <alpine.LFD.2.11.1406041540520.21183@denkbrett>
 <20140604161123.GG5004@htj.dyndns.org>
 <alpine.LFD.2.11.1406041852220.1590@denkbrett>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1406041852220.1590@denkbrett>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 06:56:14PM +0200, Sebastian Ott wrote:
> In your git tree you've used me as the patch author but that should be
> Heiko. Sorry if I didn't annotate this correctly - I just inlined the
> git format-patch output..

Oops, updated accordingly.

Thanks.

-- 
tejun
