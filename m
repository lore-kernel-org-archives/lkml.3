Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaJAHse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:48:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45013 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaJAHsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:48:32 -0400
Message-ID: <542BB1AF.3060501@ti.com>
Date: Wed, 1 Oct 2014 10:47:59 +0300
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: =?windows-1252?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau.dev@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>
Subject: Re: Differences between tlv320aic3x and tlv320aic31xx
References: <20140930183731.GC3907@piout.net>
In-Reply-To: <20140930183731.GC3907@piout.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 09:37 PM, Alexandre Belloni wrote:
> Hi,
>
> I'm trying to add support for the tlv320aic3104a present on a
> custom board using an am335x.
>
> I see that Benoit seemed to have been successful when using the
> tlv320aic3x driver with minor modifications.
> http://mailman.alsa-project.org/pipermail/alsa-devel/2013-January/058966.html
>
> On the other hand, in the past, I've used a tlv320aic3100 with the
> tlv320aic31xx driver.
>
> My plan for now is to use the tlv320aic3x driver with snd-soc-evm as
> this is the one it is using (it is using .codec_dai_name =
> "tlv320aic3x-hifi").
>
> I had no luck until now but I still have to review my pinmuxing. But
> before I investigate to much, can you confirm what codecs are supported
> by which driver? I'm pretty sure that would be a nice addition to the
> documentation too.
> 0

Hi Alexandre,
Based on a brief look at the data sheet I am afraid you will not have 
any luck using tlv320aic3x driver with tlv320aic3104. tlv320aic31xx is a 
better match, but sill not close enough.

Based on the register map you may have a change to get the codec working 
using tlv320aic32x4 driver. At least the register map appears to be a 
pretty good match. However, I have no experience either with the driver 
or the codec.

Best regards,
Jyri
