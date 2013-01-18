Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3ARUzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:55:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25031 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3ARUzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:55:38 -0500
MIME-Version: 1.0
Message-ID: <aad182a2-a21e-4b77-88dc-db859f71ee9e@default>
Date: Fri, 18 Jan 2013 12:53:25 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org
Subject: RE: [PATCH 0/5] staging: zcache: move new zcache code base from
 ramster
References: <1358443597-9845-1-git-send-email-dan.magenheimer@oracle.com>
 <20130118204617.GB4788@kroah.com>
In-Reply-To: <20130118204617.GB4788@kroah.com>
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
> Subject: Re: [PATCH 0/5] staging: zcache: move new zcache code base from ramster
> 
> On Thu, Jan 17, 2013 at 09:26:32AM -0800, Dan Magenheimer wrote:
> > Hi Greg --
> >
> > With "old zcache" now removed, we can now move "new zcache" from its
> > temporary home (in drivers/staging/ramster) to reclaim sole possession
> > of the name "zcache".
> >
> > Note that [PATCH 2/5] will require a manual:
> >
> > # git mv drivers/staging/ramster drivers/staging/zcache
> 
> Ick, no, use git to generate the patch with rename style, and it will
> create the tiny patch that does this which I can then apply (-M is the
> option you want to 'git format-patch').
> 
> Care to resend this in that format so that I can apply this properly?

Will do.  You learn something new (-M) every day.

Thanks,
Dan
