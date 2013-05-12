Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab3ELWHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 18:07:08 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46498 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3ELWHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 18:07:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAN0CFw0CZeiawHvVagDXJWVnLQsQ2BoLhL2fsxui39nsyth-kA@mail.gmail.com>
References: <CAN0CFw0CZeiawHvVagDXJWVnLQsQ2BoLhL2fsxui39nsyth-kA@mail.gmail.com>
Date: Sun, 12 May 2013 15:07:05 -0700
Message-ID: <CAN0CFw2NNgXSi6X7gMw8UCE4Hg73S+A6JS3P2GGxMFVBdG5mmg@mail.gmail.com>
Subject: Re: vlc+jack stutters on 3.9
From: Grant <emailgrant@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The 3.8 kernel works great but the 3.9 kernel causes audio to stutter
> if I use vlc and jack. If I don't use jack it works fine and mplayer
> works fine on 3.9 with or without jack. The kernel configs are the
> same within CONFIG_SND.  I've been over this on the vlc mailing list:
>
> http://vlc-videolan.10979.n7.nabble.com/vlc-stutters-on-3-9-linux-kernel-td5440.html
>
> I submitted a vlc bug but it was closed and I was told it is a kernel
> regression and I should contact the kernel folks:
>
> https://trac.videolan.org/vlc/ticket/8617
>
> - Grant

Could this from dmesg be related?  I'm on a Dell XPS 13 with the latest BIOS:

[drm] Wrong MCH_SSKPD value: 0x16040307
[drm] This can cause pipe underruns and display issues.
[drm] Please upgrade your BIOS to fix this.
[drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2

- Grant
