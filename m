Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3GIEYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 00:24:35 -0400
Received: from ozlabs.org ([203.10.76.45]:57960 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab3GIEYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 00:24:33 -0400
From: Michael Neuling <mikey@neuling.org>
To: Alexander Graf <agraf@suse.de>
cc: Bharat Bhushan <r65777@freescale.com>, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        scottwood@freescale.com, Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: Re: [PATCH 0/2] powerpc: allow kvm to use kerel debug framework
In-reply-to: <C4D71A1A-3D5B-4C9C-A26B-9EAFFD9D87C5@suse.de>
References: <1372918546-15075-1-git-send-email-Bharat.Bhushan@freescale.com> <C4D71A1A-3D5B-4C9C-A26B-9EAFFD9D87C5@suse.de>
Comments: In-reply-to Alexander Graf <agraf@suse.de>
   message dated "Tue, 09 Jul 2013 03:00:16 +0200."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Tue, 09 Jul 2013 14:24:32 +1000
Message-ID: <14504.1373343872@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Graf <agraf@suse.de> wrote:

> 
> On 04.07.2013, at 08:15, Bharat Bhushan wrote:
> 
> > From: Bharat Bhushan <bharat.bhushan@freescale.com>
> > 
> > This patchset moves the debug registers in a structure, which allows
> > kvm to use same structure for debug emulation.
> > 
> > Note: Earilier a patchset "https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-June/108132.html"
> > was sent which is a bunch of six patches. That patchset is divided into two parts:
> > 	1) powerpc specific changes (These 2 patches are actually have those changes)
> > 	2) KVM specific changes (will send separate patch on agraf repository)
> 
> Mikey, if you like those could you please apply the into a topic
> branch and get that one merged with Ben? I'd also pull it into my tree
> then.

benh would pull these directly.  

I'll have a chat with him to see if he wants my ACK before he does that.

Mikey
