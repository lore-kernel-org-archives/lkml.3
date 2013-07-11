Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab3GKHbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:31:33 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.110]:54790 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755786Ab3GKHbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:31:31 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-15.tower-200.messagelabs.com!1373527889!14613272!1
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <51DE5F1A.8010209@digi.com>
Date: Thu, 11 Jul 2013 09:30:34 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
Subject: MXS persistent bits driver
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Linux 2.6.35 had a driver for sysfs access to the MXS persistent bits 
(drivers/misc/mxs-persistent.c).
I haven't seen this is supported upstream. Is anybody working on that?
Where would such a driver fit?

Best regards,
--
Hector Palacios
