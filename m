Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaEYSnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 14:43:42 -0400
Received: from mout.gmx.net ([212.227.15.18]:59386 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaEYSnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 14:43:40 -0400
Message-ID: <1401043415.7538.11.camel@schoellingm.dzne.de>
Subject: Re: [PATCH] staging: gdm72xx: use time_before()
From: Manuel Schoelling <manuel.schoelling@gmx.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, arnd@arndb.de, peter.p.waskiewicz.jr@intel.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        khoroshilov@ispras.ru
Date: Sun, 25 May 2014 20:43:35 +0200
In-Reply-To: <20140525183305.GA11364@kroah.com>
References: <1401023339-29712-1-git-send-email-manuel.schoelling@gmx.de>
	 <20140525181431.GA20614@kroah.com>
	 <1401042273.7538.10.camel@schoellingm.dzne.de>
	 <20140525183305.GA11364@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:4XmGdgiI85JRfSUmzHJozr/sDtpV7xJR3ANW8yOpDGhe3WqRTj7
 43VaezU3fjNuSOQPjeRA1+WYU8aU9/Ue9gBa/piVZvYWhwdFFsQ57/PQHtyLgVbf3Mhzru5
 KkCuFMe6ho3lKAkMo/VGjh2cZs7mayaWo5GrtWKEj1lx/4ORIZYJarvBhvNu2a8QFfmlpvE
 XZ9poRobPdS4V6bD3Xecg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On So, 2014-05-25 at 11:33 -0700, Greg KH wrote:
> On Sun, May 25, 2014 at 08:24:33PM +0200, Manuel Schoelling wrote:
> > On So, 2014-05-25 at 11:14 -0700, Greg KH wrote:
> > > On Sun, May 25, 2014 at 03:08:59PM +0200, Manuel Schölling wrote:
> > > > To be future-proof and for better readability the time comparisons are
> > > > modified to use time_before() instead of plain, error-prone math.
> > > > 
> > > > Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
> > > > ---
> > > >  drivers/staging/gdm72xx/gdm_usb.c |    2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > This patch doesn't apply, can you please refresh it against my latest
> > > tree and resend?
> > That's weird. I pulled the lastest master from Linus and rebased the
> > patch, but no modification of my patch was required (latest commit
> > before my patch to that file was
> > 8943a92fc257c439ffe55fb0f9896be57c58c56b according to my repo). 
> > 
> > Maybe you have a more recent version than Linus?
> 
> 
> I have a much different version from Linus, with a few thousand patches
> added, otherwise how would I be able to queue up stuff to go to Linus
> for the next kernel release?  :)
> 
> For the staging patches, either use the linux-next tree (which you
> should use for all kernel development), or my staging.git tree, and the
> staging-next branch on git.kernel.org, which is what gets pulled into
> linux-next every week-day.
> 
> If you have more questions about this, take a look at
> Documentation/development-process/  it should explain how patches move
> to Linus and why working against Linus's tree isn't going to get you
> very far.
Ok, thanks for your answer, Greg. I will use the linux-next tree and send you a new version of that patch today.

Bye,

Manuel

> thanks,
> 
> greg k-h


