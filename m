Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaIVCMB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 22:12:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaIVCMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 22:12:00 -0400
Date: Sun, 21 Sep 2014 19:11:59 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: nick <yocto6@gmail.com>
Cc: Peter Chen <Peter.Chen@freescale.com>,
        "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>,
        "oneukum@suse.de" <oneukum@suse.de>,
        "himangi774@gmail.com" <himangi774@gmail.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FIX ME in  oxu210p-hcd.c
Message-ID: <20140922021159.GA28285@kroah.com>
References: <541DB6BF.7090909@gmail.com>
 <541DB8C1.2000101@gmail.com>
 <2d062bb368d94327b89cba3d547bff9d@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <541F8370.4040705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541F8370.4040705@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 10:03:28PM -0400, nick wrote:
> 
> 
> On 14-09-21 07:53 PM, Peter Chen wrote:
> > 
> >  
> >> Subject: Re: FIX ME in oxu210p-hcd.c
> >>
> >>
> >> I found a unfixed FIX ME in the file stated in my above message. I am
> >> wondering what to set hcd->self.comtroller->dma_mask to as it's now been
> >> defined to NULL and clearly even as a newbie this seem incorrect.
> >> Regards Nick
> > 
> > Usually, it is set at its controller driver or pass through through device tree or
> > platform data.
> > 
> > Peter
> > 
> Sorry Peter,
> I apologize for asking for more help here but I will paste the function below and with my changes.
> Please let me known if I am wrong and how to fix it as I new here.
> Sorry for Wasting Your Time,

Then please do not.  Just because your other email addresses were banned
from lkml, don't keep popping up and bothering people, it's rude, and
will cause this address to be banned as well.

