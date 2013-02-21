Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3BUWFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:05:55 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:54358 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3BUWFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:05:54 -0500
Date: Thu, 21 Feb 2013 14:06:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, stable <stable@vger.kernel.org>,
        bskeggs@redhat.com, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable request] fix for nouveau mem corruption [was: WARNING:
 at drivers/gpu/drm/nouveau/core/core/mm.c:242]
Message-ID: <20130221220628.GA28485@kroah.com>
References: <5122021F.1060207@suse.cz>
 <20130218232335.GA9730@joi.lan>
 <5122BC8A.6040503@suse.cz>
 <20130219070744.GA3032@joi.lan>
 <5124E1E9.5060607@suse.cz>
 <20130220185732.GA3071@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220185732.GA3071@joi.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 07:57:32PM +0100, Marcin Slusarz wrote:
> On Wed, Feb 20, 2013 at 03:47:05PM +0100, Jiri Slaby wrote:
> > On 02/19/2013 08:07 AM, Marcin Slusarz wrote:
> > >>> Crash/warning should be fixed by commit cfd376b6bfccf33782a0748a9c70f7f752f8b869
> > >>> "drm/nouveau/vm: fix memory corruption when pgt allocation fails".
> > >>
> > >> Oh, thanks for the pointer. Could that bug cause real "memory
> > >> corruption"? As we're hunting one there...
> > > 
> > > Yes.
> > > 
> > >> Isn't this a stable-3.7 candidate?
> > > 
> > > Should have been :/.
> > 
> > Ok, if you have no objections: stable fellows, please consider the
> > commit above for stable inclusion. As far as I can tell this is only
> > applicable for 3.7 -- Marcin?
> 
> Correct. Please apply it for 3.7.x.

Now applied, thanks.

greg k-h
