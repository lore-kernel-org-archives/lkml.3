Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3JYIF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:05:28 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:43748 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3JYIFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:05:22 -0400
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver v2
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <20131024100942.GA13614@kroah.com>
References: <1382544921-17012-1-git-send-email-haver@linux.vnet.ibm.com>
	 <20131024100942.GA13614@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 25 Oct 2013 10:05:14 +0200
Message-ID: <1382688314.7782.8.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102508-0342-0000-0000-000006A882E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Donnerstag, den 24.10.2013, 11:09 +0100 schrieb Greg KH:
> On Wed, Oct 23, 2013 at 06:15:21PM +0200, Frank Haverkamp wrote:
> > Rework comments:
> >  o Removed __DATE__ macros as suggested by Michal Marek
> >  o Removed startup pr_info() as suggested by Greg KH
> > 
> > Plus some little things we found during test and review:
> >  o Removed some obsolete comments
> >  o Fixed a bug in the initialization path when
> >    genwqe_set_interrupt_capability() fails
> > 
> > Greg, I tried my luck now with git send-email. Please let
> > me know if that works better.
> 
> That's one of the the worst commit message that I've ever seen, you
> really want this as the thing that shows up in the git commit log?
> 

Of course not. Let me fix that. The first posting I did had basically
what I thought should be in the commit log for the 1st inclusion of this
driver.

> I have no idea what this code is, what it does, nor what it should do.


> Also, you are using sysfs, but have no Documetation/ABI/ modifications,
> which isn't allowed.

I will add some information there.

> I need a whole more information before I can even start to review the
> code to try to determine if it's ok or not.
> 
> greg k-h

Ok.

Regards

Frank


