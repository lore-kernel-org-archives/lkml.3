Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbaGWTl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:41:28 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:60291 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693AbaGWTl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:41:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC] arm/mach-imximx/iomux-v3: Do not export symbol without public declaration
Date: Wed, 23 Jul 2014 21:41:18 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1406120520-14390-1-git-send-email-alexander.stein@systec-electronic.com>
In-Reply-To: <1406120520-14390-1-git-send-email-alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201407232141.18946.arnd@arndb.de>
X-Provags-ID: V02:K0:sbEfayme4zYhLTm2fYkZbtCYN7N7o+pfAsgcbCqGzgn
 mGFQoh/dVnd9KwE4vzg4uVQcPD0By6grBOHHcoVRFCN24Sx5Tk
 Z90ULC1o7m3WVJICcy1Vtvgi3XeracD0nYiQ0FhEZIkVZAhWHW
 lB2aRfjrtNal6b3/6GJv/xCQFMIsG7QY3Z3c1KXyXczcz8514c
 I0zY5IPuzcZW4NbDG7GmjWgevy5HAiVLnUwHYR0nxNsmnLEjuq
 HvWd5pBR5aRnqB2vGKK7RgLouzwegDiqNptnPDZZE2nKaxhNA2
 HgwO8GwV5wayOL4qWNi2/wg5oV79kqo6jhPHlJ33ddGdYjCviD
 3lmkKiDVjjPm7wh++kfs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2014, Alexander Stein wrote:
> Both mxc_iomux_v3_setup_pad and mxc_iomux_v3_setup_multiple_pads are
> declared in iomux-v3.h which can't be used in any module. None of the
> objects in this directory is tristate. Neither can the header be included
> in out-of-tree modules.
> 
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>

Makese sense, but I think if you do this, it would be reasonable
to do the same for all three iomux implementations (v1, imx31, v3).

	Arnd
