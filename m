Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbaJ2LBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:01:47 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:53156 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369AbaJ2LBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:01:45 -0400
Message-ID: <5450C915.9030600@imgtec.com>
Date: Wed, 29 Oct 2014 11:01:41 +0000
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>
CC: John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        <linux-mips@linux-mips.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 2/4] of: Add binding document for MIPS GIC
References: <1414541562-10076-1-git-send-email-abrestic@chromium.org> <1414541562-10076-3-git-send-email-abrestic@chromium.org>
In-Reply-To: <1414541562-10076-3-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 12:12 AM, Andrew Bresticker wrote:
> +- mti,available-cpu-vectors : Specifies the list of CPU interrupt vectors
> +  to which the GIC may route interrupts.  May contain up to 6 entries, one
> +  for each of the CPU's hardware interrupt vectors.  Valid values are 2 - 7.
> +  This property is ignored if the CPU is started in EIC mode.
> +

Wouldn't it be better to have this in the reversed sense ie: 
mti,nonavailable-cpu-vectors? I think the assumption that by default 
they're all available unless something else is connected to them which 
is unlikely in most cases. It can be made optional property then.

I don't have a strong opinion about it though.

Qais
