Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3KVVih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:38:37 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58658 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab3KVVie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:38:34 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH] dt-bindings: add ARMv8 PMU binding
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1385155032-9032-1-git-send-email-robherring2@gmail.com>
Date: Fri, 22 Nov 2013 15:38:32 -0600
Cc: devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Will Deacon <will.deacon@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <A8B9EAD7-0DBA-46D7-963F-30DEA0575EE2@codeaurora.org>
References: <1385155032-9032-1-git-send-email-robherring2@gmail.com>
To: Rob Herring <robherring2@gmail.com>
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 22, 2013, at 3:17 PM, Rob Herring <robherring2@gmail.com> wrote:

> From: Rob Herring <rob.herring@calxeda.com>
> 
> Add missing "arm,armv8-pmuv3" compatible property for ARMv8 PMU.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> ---
> Documentation/devicetree/bindings/arm/pmu.txt | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/pmu.txt b/Documentation/devicetree/bindings/arm/pmu.txt
> index 343781b..3e1e498 100644
> --- a/Documentation/devicetree/bindings/arm/pmu.txt
> +++ b/Documentation/devicetree/bindings/arm/pmu.txt
> @@ -7,6 +7,7 @@ representation in the device tree should be done as under:-
> Required properties:
> 
> - compatible : should be one of
> +	"arm,armv8-pmuv3”

what about arm,armv8-pmu-v3?

- k

> 	"arm,cortex-a15-pmu"
> 	"arm,cortex-a9-pmu"
> 	"arm,cortex-a8-pmu"
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

