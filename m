Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaI2L2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:28:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33953 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaI2L2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:28:01 -0400
Message-ID: <5429423E.8030908@linaro.org>
Date: Mon, 29 Sep 2014 12:27:58 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        Kiran Padwal <kiran.padwal@smartplayin.com>
CC: Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "bjorn.andersson@sonymobile.com" <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH 3/4] ARM: DT: apq8064: Add USB OTG support
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org> <1411982127-8048-1-git-send-email-srinivas.kandagatla@linaro.org> <542933E1.8010809@smartplayin.com> <20140929105329.GA2432@leverpostej>
In-Reply-To: <20140929105329.GA2432@leverpostej>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 29/09/14 11:53, Mark Rutland wrote:
>> >Its canonical value is "okay" (although in practice anything
>> >other than "disabled" should work).
> That's not quite true, there are other "bad" values like "fail" and
> "fail-sss" documented by ePAPR. In Linux, of_device_is_available errs on
> the side of caution and checks for either "okay" or "ok", failing
> otherwise
>
> Regardless, please use the canonical "okay".
I will fix this in v2.


--srini
