Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbaDVPIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:08:48 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:57756 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933081AbaDVPIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:08:00 -0400
Message-ID: <535685CD.9080207@linaro.org>
Date: Tue, 22 Apr 2014 16:07:57 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Peter Chen <Peter.Chen@freescale.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 1/3] usb: chipidea: msm: Add device tree binding information
References: <1398159797-26917-1-git-send-email-iivanov@mm-sol.com> <1398159797-26917-2-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1398159797-26917-2-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22/04/14 10:43, Ivan T. Ivanov wrote:
> +- interrupts:   interrupt-specifier for the controller interrupt.
> +- usb-phy:      phandle for the PHY device
> +- dr_mode:      Sould be "peripheral"
s/Sould/Should/
> +
