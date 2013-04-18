Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3DRGhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 02:37:09 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:56044 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889Ab3DRGhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 02:37:07 -0400
Message-ID: <516F9481.4080908@stericsson.com>
Date: Thu, 18 Apr 2013 08:36:49 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: ab8500: Remove unused voltage_shift field
 from struct expand_register
References: <1366210440.15800.0.camel@phoenix>
In-Reply-To: <1366210440.15800.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 04:54 PM, Axel Lin wrote:
> The voltage_shift field of struct expand_register is not used now, remove it.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Looks good.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

