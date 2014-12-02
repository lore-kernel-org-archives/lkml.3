Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaLBOPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:15:55 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45572 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaLBOPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:15:54 -0500
Date: Tue, 2 Dec 2014 22:15:43 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: kernel@pengutronix.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: vf610: enable watchdog for Cortex-A5 dt's
Message-ID: <20141202141542.GL2411@dragon>
References: <1417131336-3136-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417131336-3136-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 12:35:36AM +0100, Stefan Agner wrote:
> During restructuring of the device tree files the watchdog was
> changed to be disabled by default. However, since the watchdog
> instance is dedicated to the Cortex-A5, enable the peripheral
> by default in the base device tree vf500.dtsi.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Applied, thanks. 
