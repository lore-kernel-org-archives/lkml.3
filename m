Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3C0KmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:42:11 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:54701 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782Ab3C0KmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:42:10 -0400
Message-ID: <5152CCFA.6040505@stericsson.com>
Date: Wed, 27 Mar 2013 11:42:02 +0100
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT 2/2] regulator: ab8500: Remove set_voltage_time_sel
 and delay setting
References: <1364377642.13084.0.camel@phoenix> <1364377709.13084.1.camel@phoenix>
In-Reply-To: <1364377709.13084.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 10:48 AM, Axel Lin wrote:
> The data sheet does not specify time delay for voltage selection,
> thus remove set_voltage_time_sel and delay setting.
>
> Note, currently set_voltage_time_sel callback returns 0 due to missing
> delay settings.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Looks good.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
