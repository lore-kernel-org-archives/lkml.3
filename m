Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaIILLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:11:49 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:42075 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaIILLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:11:47 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.142.230]
In-Reply-To: <1410260825-21667-1-git-send-email-guodong.xu@linaro.org>
References: <1410260825-21667-1-git-send-email-guodong.xu@linaro.org>
Date: Tue, 9 Sep 2014 19:11:46 +0800
Message-ID: <CAFRkauBhzHot9=z-Jv-rvdLaSWSfyYSULMKqcVX+tiHcXrxt_g@mail.gmail.com>
Subject: Re: [PATCH] regulator: mc13xxx: add missing of_node_get()
From: Axel Lin <axel.lin@ingics.com>
To: Guodong Xu <guodong.xu@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-09 19:07 GMT+08:00 Guodong Xu <guodong.xu@linaro.org>:
> mc13xxx_parse_regulators_dt() goes through dt tree to search for regulator
> sub-nodes. For each matched node, later on it will be used and registered
> into a regulator_dev.
>
> of_node_get() should be called to increase its refcount.

I think it's done by regulator core:

commit 63c7c9e16c8e92cc069854f2babdf82d2d38e4c7
regulator: core: Get and put regulator of_node

Regards,
Axel
