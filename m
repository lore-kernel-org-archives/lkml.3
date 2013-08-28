Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3H1SNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:13:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44827 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3H1SNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:13:12 -0400
Subject: Re: [PATCH v3 1/2] devicetree: serial: Document msm_serial bindings
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1377648764-23453-2-git-send-email-sboyd@codeaurora.org>
Date: Wed, 28 Aug 2013 13:13:13 -0500
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <3F130457-CA92-4319-A2E9-019F17815810@codeaurora.org>
References: <1377648764-23453-1-git-send-email-sboyd@codeaurora.org> <1377648764-23453-2-git-send-email-sboyd@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 27, 2013, at 7:12 PM, Stephen Boyd wrote:

> Let's fix up the msm serial device bindings so that it's clearer
> what hardware is supported. Instead of using hsuart (for high
> speed uart) let's use uartdm because that matches the actual name
> of the hardware. Also, let's add the version information in case
> we need to differentiate between different versions of the
> hardware in the future. Finally, lets specify that clocks are
> required (the clock bindings didn't exist when the original
> binding was written) and also specify dma bindings just in case
> we want to use it in software. We split the binding into two
> files to make it clearer what's required and not required.
> 
> Cc: David Brown <davidb@codeaurora.org>
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> .../devicetree/bindings/tty/serial/msm_serial.txt  | 27 -----------
> .../bindings/tty/serial/qcom,msm-uart.txt          | 25 ++++++++++
> .../bindings/tty/serial/qcom,msm-uartdm.txt        | 53 ++++++++++++++++++++++
> 3 files changed, 78 insertions(+), 27 deletions(-)
> delete mode 100644 Documentation/devicetree/bindings/tty/serial/msm_serial.txt
> create mode 100644 Documentation/devicetree/bindings/tty/serial/qcom,msm-uart.txt
> create mode 100644 Documentation/devicetree/bindings/tty/serial/qcom,msm-uartdm.txt

Acked-by: Kumar Gala <galak@codeaurora.org>

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

