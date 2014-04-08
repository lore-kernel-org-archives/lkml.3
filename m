Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbaDHWCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:02:34 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:34072 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341AbaDHWC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:02:26 -0400
Message-ID: <534471F0.5050800@mm-sol.com>
Date: Wed, 09 Apr 2014 01:02:24 +0300
From: Stanimir Vabanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] ARM: qcom: Add initial APQ8064 SoC and IFC6410 board
 device trees
References: <1396972391-11759-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1396972391-11759-1-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

<snip>

> +		intc: interrupt-controller@2000000 {
> +			compatible = "qcom,msm-qgic2";
> +			interrupt-controller;
> +			#interrupt-cells = <3>;
> +			reg = < 0x02000000 0x1000 >,
> +			      < 0x02002000 0x1000 >;

extra space around numbers.

I wonder what is the preferred way of describing the properties:

reg = <0x02000000 0x1000>,
      <0x02002000 0x1000>;
or

reg = <0x02000000 0x1000>, <0x02002000 0x1000>;

This file mixes the above two ways of describing.

> +		};
> +
> +		timer@200a000 {
> +			compatible = "qcom,kpss-timer", "qcom,msm-timer";
> +			interrupts = <1 1 0x301>,
> +				     <1 2 0x301>,
> +				     <1 3 0x301>;
> +			reg = <0x0200a000 0x100>;
> +			clock-frequency = <27000000>,
> +					  <32768>;
> +			cpu-offset = <0x80000>;
> +		};
> +
> +		acc0: clock-controller@2088000 {
> +			compatible = "qcom,kpss-acc-v1";
> +			reg = <0x02088000 0x1000>, <0x02008000 0x1000>;
> +		};
> +

regards,
Stan

