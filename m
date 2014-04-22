Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbaDVPH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:07:57 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34107 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbaDVPHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:07:47 -0400
Message-ID: <535685C0.5070800@linaro.org>
Date: Tue, 22 Apr 2014 16:07:44 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v6 04/19] usb: phy: msm: Migrate to Managed Device Resource
 allocation
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com> <1398158438-21579-5-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1398158438-21579-5-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22/04/14 10:20, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
> Move memory, regulators, clocks and irq allocation to
> devm_* variants. Properly check for valid clk handles.
>
>
> -module_platform_driver_probe(msm_otg_driver, msm_otg_probe);
> +module_platform_driver(msm_otg_driver);

This change doesn’t match the log.

>
>   MODULE_LICENSE("GPL v2");
>   MODULE_DESCRIPTION("MSM USB transceiver driver");
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
