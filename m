Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3DVKcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:32:41 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.5]:5610 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993Ab3DVKcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:32:39 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-10.tower-28.messagelabs.com!1366626756!25953790!1
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <517511C0.1020006@digi.com>
Date: Mon, 22 Apr 2013 12:32:32 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Subject: How usable is spi-mxs driver?
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I had the feeling that the MXS SPI driver was rather useless due to the SPI being only 
half-duplex on i.MX28, but it looks like people's using it so I was wondering what 
kind of SPI devices can be driven with it, or if there is any trick that allows 
bi-directional communication.

Thanks,
-- 
Héctor Palacios
