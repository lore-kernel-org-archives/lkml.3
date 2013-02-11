Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab3BKVxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 16:53:54 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:36076 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3BKVxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 16:53:53 -0500
X-Auth-Info: vBHqYg5UrjIHHxxyTCKj8J6egNtoAkcO1vEZL+xgDyY=
Date: Mon, 11 Feb 2013 22:53:45 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@list.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] powerpc/5200: Add Lite5200 on-board LEDs as devices
Message-ID: <20130211225345.08dd112b@crub>
In-Reply-To: <1360310571-31494-1-git-send-email-grant.likely@secretlab.ca>
References: <1360310571-31494-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Feb 2013 08:02:50 +0000
Grant Likely <grant.likely@secretlab.ca> wrote:

> The Lite5200 evaluation board has a number of debug LEDs that Linux
> doesn't know about yet. This change adds a gpio-leds stanza to the
> lite5200 device tree so that the correct driver can get hooked up.
> 
> Also, make use of the dtc labels feature to reduce the number of source
> lines required to add the gpio-controller property to the general
> purpose timer nodes. In addition, the required #gpio-cells properties
> are added to the common mpc5200b dtsi include file so that each board
> doesn't need to add them explicitly. This still doesn't enable gpio
> mode, 'gpio-controller' is required for that, but it means less work
> needs to be done by board ports.
> 
> Cc: Anatolij Gustschin <agust@denx.de>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/powerpc/boot/dts/lite5200b.dts |   23 +++++++++++++++++++----
>  arch/powerpc/boot/dts/mpc5200b.dtsi |   25 +++++++++++++++++--------
>  2 files changed, 36 insertions(+), 12 deletions(-)

Applied, thanks!

Anatolij
