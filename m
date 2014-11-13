Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbaKMJg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:36:29 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:58088 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbaKMJg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:36:26 -0500
MIME-Version: 1.0
In-Reply-To: <20141112141856.GA26488@ulmo>
References: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
 <1415779051-26410-5-git-send-email-tomeu.vizoso@collabora.com> <20141112141856.GA26488@ulmo>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Thu, 13 Nov 2014 10:36:05 +0100
X-Google-Sender-Auth: Sj9e2D2B-YXlvSfGMZCnG-_23fU
Message-ID: <CAAObsKCxZvZE_3DOW3KXJUtdqy6s-vVYLQMzmQGLiurPsPjxWg@mail.gmail.com>
Subject: Re: [PATCH v4 04/13] of: document new emc-timings subnode in nvidia,tegra124-car
To: Thierry Reding <thierry.reding@gmail.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2014 15:18, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Wed, Nov 12, 2014 at 08:56:27AM +0100, Tomeu Vizoso wrote:
> [...]
>>  Example SoC include file:
>>
>>  / {
>> -     tegra_car: clock {
>> +     tegra_car: clock@60006000 {
>>               compatible = "nvidia,tegra124-car";
>>               reg = <0x60006000 0x1000>;
>>               #clock-cells = <1>;
>> @@ -60,4 +83,23 @@ Example board file:
>>       &tegra_car {
>>               clocks = <&clk_32k> <&osc>;
>>       };
>> +
>> +     clock@60006000 {
>> +             emc-timings@3 {
>
> Shouldn't this be following the same naming scheme as the memory
> controller's subnodes?
>
>> +                     nvidia,ram-code = <3>;
>> +
>> +                     timing@12750000 {
>
> And this?

Thanks for pointing these out. My bad.

Regards,

Tomeu
