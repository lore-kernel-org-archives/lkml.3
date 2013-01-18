Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3ARUzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:55:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30858 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3ARUzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:55:07 -0500
MIME-Version: 1.0
Message-ID: <9d1e65ec-9a8d-4639-8825-97a2ae897f93@default>
Date: Fri, 18 Jan 2013 12:54:41 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org
Subject: RE: [PATCH 2/5] staging: zcache: rename ramster to zcache
References: <1358443597-9845-1-git-send-email-dan.magenheimer@oracle.com>
 <1358443597-9845-3-git-send-email-dan.magenheimer@oracle.com>
 <20130118204655.GC4788@kroah.com>
In-Reply-To: <20130118204655.GC4788@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, January 18, 2013 1:47 PM
> To: Dan Magenheimer
> Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; linux-mm@kvack.org; ngupta@vflare.org;
> Konrad Wilk; sjenning@linux.vnet.ibm.com; minchan@kernel.org
> Subject: Re: [PATCH 2/5] staging: zcache: rename ramster to zcache
> 
> On Thu, Jan 17, 2013 at 09:26:34AM -0800, Dan Magenheimer wrote:
> > In staging, rename ramster to zcache
> >
> > The original zcache in staging was a "demo" version, and this new zcache
> > is a significant rewrite.  While certain disagreements were being resolved,
> > both "old zcache" and "new zcache" needed to reside in the staging tree
> > simultaneously.  In order to minimize code change and churn, the newer
> > version of zcache was temporarily merged into the "ramster" staging driver
> > which, prior to that, had at one time heavily leveraged the older version
> > of zcache.  So, recently, "new zcache" resided in the ramster directory.
> >
> > Got that? No? Sorry, temporary political compromises are rarely pretty.
> >
> > The older version of zcache is no longer being maintained and has now
> > been removed from the staging tree.  So now the newer version of zcache
> > can rightfully reclaim sole possession of the name "zcache".
> >
> > This patch is simply a manual:
> >
> >   # git mv drivers/staging/ramster drivers/staging/zcache
> >
> > so the actual patch diff has been left out.
> >
> > Because a git mv loses history, part of the original description of
> > the changes between "old zcache" and "new zcache" is repeated below:
> 
> git mv does not loose history, it can handle it just fine.

OK will fix.  Heh, apparently, you learn something wrong on the internet
("git mv loses history") every day, too. :-(

Thanks,
Dan
