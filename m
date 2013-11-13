Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab3KMKsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:48:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57288 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3KMKsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:48:46 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH v6 2/2] PWM: atmel-pwm: add device tree binding document
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1383292811-11343-1-git-send-email-voice.shen@atmel.com>
Date: Wed, 13 Nov 2013 04:48:40 -0600
Cc: devicetree@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com,
        alexandre.belloni@free-electrons.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thierry Reding <thierry.reding@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1B703716-8202-4A87-8604-12B200EBF886@codeaurora.org>
References: <1383292811-11343-1-git-send-email-voice.shen@atmel.com>
To: Bo Shen <voice.shen@atmel.com>
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 1, 2013, at 3:00 AM, Bo Shen <voice.shen@atmel.com> wrote:

> Add atmel pwm driver device tree binding document
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> 
> ---
> Changes in v6:
>  - New, split binding document as a separate patch
> 
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
> .../devicetree/bindings/pwm/atmel-pwm.txt          |   41 ++++++++++++++++++++
> 1 file changed, 41 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/pwm/atmel-pwm.txt

Acked-by: Kumar Gala <galak@codeaurora.org>

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

