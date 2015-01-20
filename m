Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbbATQUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:20:50 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54036 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbbATQUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:20:48 -0500
Message-ID: <54BE805A.3060300@wwwdotorg.org>
Date: Tue, 20 Jan 2015 09:20:42 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/11] ARM: tegra: Use the generated pinmux data
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com> <1421338359-27467-3-git-send-email-tomeu.vizoso@collabora.com> <54B7F7F7.1020202@wwwdotorg.org> <CAAObsKAaanrrSYd7gmLAS4K_G9fuU=WmsMXQk0G85hfy_XdE5Q@mail.gmail.com>
In-Reply-To: <CAAObsKAaanrrSYd7gmLAS4K_G9fuU=WmsMXQk0G85hfy_XdE5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 06:59 AM, Tomeu Vizoso wrote:
> On 15 January 2015 at 18:25, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 01/15/2015 09:12 AM, Tomeu Vizoso wrote:
>>>
>>> Google has submitted a board config for the pinmux programming of the
>>> Nyan Big board. Use the whole of it as it's generated to make it easier
>>> to update as the configuration gets fixed in the future.
>>
>>
>> Submitted to where? I assume you mean tegra-pinmux-scripts. I don't see a
>> Nyan/Nyan-big configuration there yet. IIRC (and I might not) one was
>> posted, but there were some review comments that aren't yet addressed?
>
> Yeah, that's what I meant by submitted. TTBOMK the v2 doesn't have any
> comments pending of being addressed?

There's a thread where you and Andrew are discussing the settings for a 
bunch of the pins, and the differences between Big and Blaze. It didn't 
seem to me that the resolution was that the V2 patch was fine as is, but 
perhaps that's what the thread meant!

Either way, it'd be nice if Andrew or someone else from ChromeOS could 
give an acked-by/reviewed-by for the patch if it's OK as is. That way, 
I'll know it's good without any doubts.
