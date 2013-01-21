Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3AUUPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:15:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52644 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3AUUPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:15:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 12/15] USB: gadget/freescale: disable non-multiplatform drivers
Date: Mon, 21 Jan 2013 20:15:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Felipe Balbi <balbi@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, linux-usb@vger.kernel.org
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <20130121184138.GB10106@arwen.pp.htv.fi> <20130121185716.GA26754@kroah.com>
In-Reply-To: <20130121185716.GA26754@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301212015.31312.arnd@arndb.de>
X-Provags-ID: V02:K0:YSTsh2PoFFcWgnEYKj/99LSK+KDuIf3Vq+XMvBaw0pA
 7Zi5L9+zjOFP4gBY48/w+zMXISVYNTvdD4ishMylmmrffNTC/Q
 X+p2r2aNOoNmpA8SWatCSyhy3xnznOWN6Xi5JWG42utLxMKvd6
 CjIMUzcEjAiboVroH5doPK9CM2W3txxNP/LpWZCvoYoJ0zkAfS
 8LxbZeUDwJ6OFj3/0dZs8thbj3YaNM9Q3EZ7W967l6nojYa+Hv
 in889ZQ15kJzH8EuxEx0Bbm+PYWISTvvkNFhluqT5cXnneup4g
 nY0xbKvyVUkxiMPTSjRq5xLZJVDWaUx4lG+X7wvoukfvWAeF2J
 20LYAyhRmSIdZnLqsb8E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Greg Kroah-Hartman wrote:
> On Mon, Jan 21, 2013 at 08:41:38PM +0200, Felipe Balbi wrote:
>
> > NAK, I prefer to see a real fix for the problem (which in fact is
> > already in my fixes branch).
> 
> I'll pull that branch now, sorry for the delay.
> 

Ok, great! Thanks a lot, both of you,

	Arnd
