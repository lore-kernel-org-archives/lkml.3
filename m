Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbaDAEDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:03:46 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52685 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaDAEDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:03:45 -0400
MIME-Version: 1.0
X-Originating-IP: [111.240.57.18]
In-Reply-To: <1395389720.29259.1.camel@phoenix>
References: <1395389720.29259.1.camel@phoenix>
Date: Tue, 1 Apr 2014 12:03:44 +0800
Message-ID: <CAFRkauBUy42_y1-9Fs_T6RuK8re0m-kJ9Rvf6X1BVJ9sPk4RrQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: s2mpa01: Don't check enable_shift before
 setting enable ramp rate
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-21 16:15 GMT+08:00 Axel Lin <axel.lin@ingics.com>:
> Current code misses updating the register when enable_shift is 0.
> e.g. S2MPA01_BUCK4_RAMP_EN_SHIFT is 0.

Hi Sachin and Krzysztof,

I think these 2 patches are bug fix.
Any comment on this patch serial?

Regards,
Axel
