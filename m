Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaHRUYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 16:24:43 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:56348 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaHRUYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 16:24:42 -0400
Message-ID: <53F26105.9000907@cogentembedded.com>
Date: Tue, 19 Aug 2014 00:24:37 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, peter.chen@freescale.com,
        s.hauer@pengutronix.de, kernel@pengutronix.de, shawn.guo@freescale.com,
        balbi@ti.com, gregkh@linuxfoundation.org
CC: jingchang.lu@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 7/7] ARM: dts: vf610-twr: Add USB support
References: <cover.1408391385.git.stefan@agner.ch> <07491836b9c23a82b7a33972a5c71f2676ceaf71.1408391385.git.stefan@agner.ch>
In-Reply-To: <07491836b9c23a82b7a33972a5c71f2676ceaf71.1408391385.git.stefan@agner.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/19/2014 12:07 AM, Stefan Agner wrote:

> Add USB support for Freescale Vybrid tower. The USB hosts over-current
> protection signal is not connected is not connected to the PHY's over-

    Yes, we all understood that it's not connected, no need to repeat. ;-)

> current protection, hence we need to disable it.

> Signed-off-by: Stefan Agner <stefan@agner.ch>

WBR, Sergei

