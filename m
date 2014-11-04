Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaKDICK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:02:10 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51163 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaKDICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:02:08 -0500
Date: Tue, 4 Nov 2014 16:02:00 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: kernel@pengutronix.de, arnd@arndb.de, b35083@freescale.com,
        bpringlemeir@nbsps.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 0/4] ARM: vf610: restructure device trees
Message-ID: <20141104080159.GI10821@tiger>
References: <1414960607-29316-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414960607-29316-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 09:36:43PM +0100, Stefan Agner wrote:
> Stefan Agner (4):
>   ARM: dts: vf610: assign oscillator to clock module
>   ARM: imx: clk-vf610: get input clocks from assigned clocks
>   ARM: dts: vf610: create generic base device trees
>   ARM: dts: vf500-colibri: add Colibri VF50 support

Applied all, thanks.
