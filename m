Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaBSWMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:12:44 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:34924 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaBSWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:12:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAEPRUYr8_qpL65Q0jCnLXHsZpb27DxuiF6JsZb6eRb4JOX2evg@mail.gmail.com>
References: <1392845512-31333-1-git-send-email-mporter@linaro.org>
	<CAEPRUYr8_qpL65Q0jCnLXHsZpb27DxuiF6JsZb6eRb4JOX2evg@mail.gmail.com>
Date: Wed, 19 Feb 2014 14:12:34 -0800
Message-ID: <CAPdLdqkLV+NODgGS5NxvHaD1P_zpoeEhTnZunEGsR9OZXhWFSw@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: dts: remove bcm11351-brt.dts
From: Markus Mayer <markus.mayer@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>
Cc: Matt Porter <mporter@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>, Alex Elder <elder@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 February 2014 13:37, Christian Daudt <bcm@fixthebug.org> wrote:
> On Wed, Feb 19, 2014 at 1:31 PM, Matt Porter <mporter@linaro.org> wrote:
>> The BCM11351 BRT board will never see the light of day. Remove the BRT
>> dts since it is not maintainable.
>>
>> Reviewed-by: Alex Elder <elder@linaro.org>
>> Signed-off-by: Matt Porter <mporter@linaro.org>
>> ---
>> Changes since v1:
>>         - remove bcm11351-brt from Makefile
>>
>>  arch/arm/boot/dts/Makefile         |  3 +--
>>  arch/arm/boot/dts/bcm11351-brt.dts | 54 --------------------------------------
>>  2 files changed, 1 insertion(+), 56 deletions(-)
>>  delete mode 100644 arch/arm/boot/dts/bcm11351-brt.dts
>>
>
> R.I.P bcm11351...
>
> Reviewed-by: Christian Daudt <bcm@fixthebug.org>

There goes our original guinea pig.

Reviewed-by: Markus Mayer <markus.mayer@linaro.org>

-- 
Markus Mayer
Broadcom Landing Team
