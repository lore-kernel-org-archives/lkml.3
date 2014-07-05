Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbaGEArd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 20:47:33 -0400
Received: from plane.gmane.org ([80.91.229.3]:39500 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbaGEArc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 20:47:32 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH 3.14 00/59] 3.14.11-stable review
Date: Sat, 5 Jul 2014 00:47:17 +0000 (UTC)
Message-ID: <pan.2014.07.05.00.47.17@googlemail.com>
References: <20140704221539.544876024@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5b0045d7.dip0.t-ipconnect.de
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
 git://git.gnome.org/pan2)
Cc: stable@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2014 15:18:49 -0700, Greg Kroah-Hartman wrote:

> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda - Adjust speaker HPF and add LED support for HP Spectre 13

Building on Gentoo ~amd64 with gcc 4.9.0 this patch (#59) fails:

  LD [M]  sound/pci/snd-intel8x0.o CC [M]  sound/pci/hda/patch_sigmatel.o
sound/pci/hda/patch_sigmatel.c: In function 'stac92hd95_fixup_hp_led':
sound/pci/hda/patch_sigmatel.c:4143:3: error: implicit declaration of
function 'codec_dbg' [-Werror=implicit-function-declaration]
   codec_dbg(codec, "mute LED gpio %d polarity %d\n",
   ^
cc1: some warnings being treated as errors
scripts/Makefile.build:308: recipe for target 'sound/pci/hda/patch_sigmatel.o' failed

-h

