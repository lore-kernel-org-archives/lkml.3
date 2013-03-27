Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab3C0Kfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:35:50 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:43055 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804Ab3C0Kft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:35:49 -0400
Message-ID: <5152CB7D.6050403@stericsson.com>
Date: Wed, 27 Mar 2013 11:35:41 +0100
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT 1/2] regulator: ab8500: Add missing enable_time settings
References: <1364377642.13084.0.camel@phoenix>
In-Reply-To: <1364377642.13084.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 10:47 AM, Axel Lin wrote:
> Base on the data provide by Bengt Jönsson, add below enable_time settings:
>
> Worst case enable time from data sheet:
> Vana: enable time = 140 us
> Vaux1/2: enable time = 200 us
> Vaux3: enable time = 450 us
> Vintcore: enable time = 750 us
> Vamic1/2: enable time = 500 us
> Vdmic: enable time = 420 us
> VTVout: enable time = 500 us
> Vaudio: enable time = 140 us
> Vusb: enable time = 150 us
>
> This discussion thread is available at: https://lkml.org/lkml/2013/3/26/795
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>
Looks good.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
