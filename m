Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3LNX5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 18:57:38 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:45693 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab3LNX5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 18:57:36 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Alex Elder <alex.elder@linaro.org>, "Christian Daudt" <bcm@fixthebug.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Rob Landley" <rob@landley.net>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Stephen Warren" <swarren@wwwdotorg.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <529F4B4F.4020405@linaro.org>
Cc: "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>
References: <529F4B0F.2020801@linaro.org> <529F4B4F.4020405@linaro.org>
Message-ID: <20131214235731.26321.53050@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2 2/3] clk: bcm281xx: add initial clock framework support
Date: Sat, 14 Dec 2013 15:57:31 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alex Elder (2013-12-04 07:33:35)
> +       return true;
> +}
> +
> +/* A bit position must be less than the number of bits in a 32-bit
> register. */

Hi Alex,

The patch is corrupt at line 634 and several other places below.  Did
you edit it manually? I'm happy with the series after reviewing it but
it cannot be applied. Can you fix the issue and send me a pull request?

Thanks,
Mike
