Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab3H1SCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:02:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43919 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3H1SCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:02:12 -0400
From: Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: merging device tree binding dirs for serial bindings
Date: Wed, 28 Aug 2013 13:02:14 -0500
Message-Id: <F93329E6-1426-4197-871D-211F34455DDE@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "shawn.guo@linaro.org Guo" <shawn.guo@linaro.org>,
        "s.hauer@pengutronix.de Hauer" <s.hauer@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1283)
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We appear to have:

Documentation/devicetree/bindings/serial/

and

Documentation/devicetree/bindings/tty/serial/

Which one do we want to keep, I'd pick the first, but I don't care too much.

Also, there appears to be a duplicated (but different) binding for the fsl-imx-uart.txt in these two dirs.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

