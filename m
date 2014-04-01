Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaDAG1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:27:10 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:57351 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaDAG1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <1395389720.29259.1.camel@phoenix>
References: <1395389720.29259.1.camel@phoenix>
Date: Tue, 1 Apr 2014 11:57:07 +0530
Message-ID: <CAK9yfHyk8m3=De+ep8PkgzdZCgMgCd5sbsBhOFLGRO6eCvbMBg@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: s2mpa01: Don't check enable_shift before
 setting enable ramp rate
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On 21 March 2014 13:45, Axel Lin <axel.lin@ingics.com> wrote:
> Current code misses updating the register when enable_shift is 0.
> e.g. S2MPA01_BUCK4_RAMP_EN_SHIFT is 0.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Sachin Kamat <sachin.kamat@linaro.org>

-- 
With warm regards,
Sachin
