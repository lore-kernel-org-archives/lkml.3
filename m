Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965547Ab3DRGi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 02:38:56 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:45302 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906Ab3DRGiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 02:38:54 -0400
Message-ID: <516F94DD.1040400@stericsson.com>
Date: Thu, 18 Apr 2013 08:38:21 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulator: ab8500: Get rid of voltage_shift field
 from struct ab8500_regulator_info
References: <1366210440.15800.0.camel@phoenix> <1366210545.15800.2.camel@phoenix>
In-Reply-To: <1366210545.15800.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 04:55 PM, Axel Lin wrote:
> The voltage_shift can be calculated from voltage_mask.
> Let's remove voltage_shift fied from struct ab8500_regulator_info, this change
> can prevent missing voltage_shift setting issue.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Nice improvement.Thanks.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

