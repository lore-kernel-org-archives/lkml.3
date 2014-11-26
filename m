Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaKZT7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:59:30 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58432 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaKZT73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:59:29 -0500
Date: Wed, 26 Nov 2014 11:59:24 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] [PATCH] next: cyapa: fix inop touchpad after resume on
 Acer C720
Message-ID: <20141126195924.GA27014@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudl@cypress.com>, linux-kernel@vger.kernel.org
References: <20141124085059.GA15770@hudson.localdomain>
 <20141125100703.GA9287@hudson.localdomain>
 <fea6267ce871452683eb1a5dee1a9476@BN1PR06MB070.namprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fea6267ce871452683eb1a5dee1a9476@BN1PR06MB070.namprd06.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Wed, Nov 26, 2014 at 06:01:05AM +0000, Dudley Du wrote:
> Hi Jermiah,
      ^^^
	 Jeremiah,
> 
> Does your code merged from chromiumos gerrit?
> If so, the patch you used seems very old, because the log shown the cyapa driver module name still be "cyapa", and it has already been changed to "cyapatp" for log time.
> Currently, I have already removed all old pathces from the gerrit system, now only v11 pathces existing in gerrit system.
> Could you please try to refetch again,
> or
> could you try the v11 patches that from http://patchwork.kernel.org/bundle/dudlx/input_cyapa_v11/
> or

I am not pulling from your gerrit system.  I am pulling from linux-next.

  http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git

Yes, my bug is for an older patch, however this patch is still in
linux-next as of the latest 20140326.

  commit b1cfa7b4388285c0f0b486f152ab0cb18612c779

  http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=b1cfa7b4388285c0f0b486f152ab0cb18612c779

I replied to your latest patch set because it was working on the same
part of the code and I thought it might be related.  Perhaps your new
code fixes all the problems, I'm not sure.

> The attached zip file contians the v11 patches for chromiumos projects, same as currently existing in gerrit system.
> Besides the first and the latest patches which are specifical for chromionos, the reset pathces are exactly same as the cyapa v11 pathces that submitted to this kernel commuinty.
> 
> Thanks,
> Dudley
> 
> > -----Original Message-----
> > From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> > Sent: 2014?11?25? 18:07
> > To: Dudley Du
> > Cc: linux-kernel@vger.kernel.org
> > Subject: [BUG] [PATCH] next: cyapa: fix inop touchpad after resume on Acer C720
> >
> > On an Acer C720 running linux-next (20141124) the touchpad will become
> > inoperative after a resume.  Reloading the cyapa driver restores normal
> > +enable_irq(client->irq);
[]

-- 
- Jeremiah Mahler
