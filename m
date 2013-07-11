Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab3GKHo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:44:27 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.12]:43891 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755602Ab3GKHoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:44:25 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-3.tower-29.messagelabs.com!1373528663!26279701!2
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <51DE624C.1080208@digi.com>
Date: Thu, 11 Jul 2013 09:44:12 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        <s.trumtrar@pengutronix.de>
Subject: Re: MXS persistent bits driver
References: <51DE5F1A.8010209@digi.com>
In-Reply-To: <51DE5F1A.8010209@digi.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 09:30 AM, Hector Palacios wrote:
> Greetings,
>
> Linux 2.6.35 had a driver for sysfs access to the MXS persistent bits
> (drivers/misc/mxs-persistent.c).
> I haven't seen this is supported upstream. Is anybody working on that?
> Where would such a driver fit?

Adding Steffen Trumtrar, as I came across his patch:
http://permalink.gmane.org/gmane.linux.drivers.devicetree/31370

@Steffen, was there no answer to your questions about these being binary attributes?

Best regards,
--
Hector Palacios
