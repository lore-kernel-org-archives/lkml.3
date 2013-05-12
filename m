Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3ELB5X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 21:57:23 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:57580 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab3ELB5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 21:57:22 -0400
MIME-Version: 1.0
Date: Sat, 11 May 2013 18:57:20 -0700
Message-ID: <CAN0CFw0CZeiawHvVagDXJWVnLQsQ2BoLhL2fsxui39nsyth-kA@mail.gmail.com>
Subject: vlc+jack stutters on 3.9
From: Grant <emailgrant@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 3.8 kernel works great but the 3.9 kernel causes audio to stutter
if I use vlc and jack. If I don't use jack it works fine and mplayer
works fine on 3.9 with or without jack. The kernel configs are the
same within CONFIG_SND.  I've been over this on the vlc mailing list:

http://vlc-videolan.10979.n7.nabble.com/vlc-stutters-on-3-9-linux-kernel-td5440.html

I submitted a vlc bug but it was closed and I was told it is a kernel
regression and I should contact the kernel folks:

https://trac.videolan.org/vlc/ticket/8617

- Grant
