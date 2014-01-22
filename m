Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbaAVOzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:55:32 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:32840 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaAVOzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:55:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAH=mFZzmcp5amS-JsNApWiwgYqs70M==FUA6KoxH+oLdbZihcg@mail.gmail.com>
References: <CAH=mFZwxay59O8sHc1fKSbh=gHPghYZMPNKEVyPvXUgitx1vPg@mail.gmail.com>
	<CAH=mFZzmcp5amS-JsNApWiwgYqs70M==FUA6KoxH+oLdbZihcg@mail.gmail.com>
Date: Wed, 22 Jan 2014 06:55:28 -0800
Message-ID: <CAK2H+ee8MgXdm3eTzrkvo=R-=8U_0LOmEAKMnKga8KU04jmgCg@mail.gmail.com>
Subject: Re: Help Needed
From: Mark Knecht <markknecht@gmail.com>
To: Madhusudhan Rao Sripalle <madhu.sripalle@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 6:34 AM, Madhusudhan Rao Sripalle
<madhu.sripalle@gmail.com> wrote:
> Thanks to Randy and Ryan for the responses. The pointers are really
> helpful. Currently I am facing an issue with Ubuntu's grub not
> displaying the newly built kernel.
>
> Existing kernel on the ubuntu system is 3.2.0-23-generic. While the
> new one is 3.11.10. The Grub has/displays fedora and ubuntu each one
> and their corresponding recovery modes. On building and installing
> 3.11.10 on Ubuntu's, the newly built kernel doesn't show up in grub at
> the boot time. Kindly help. Updating grub also doesn't help.
>
> -Madhu

There are likely a lot of resources on the web to more complete
instructions but roughly speaking:

1) Mount /boot
2) Copy your new kernel binary to /boot. I.e. cp
arch/x86_64/boot/bzImage /boot/bzImage-#####
3) Edit /boot/grub/grub.conf to add the new kernel in the list of options

HTH,
Mark
