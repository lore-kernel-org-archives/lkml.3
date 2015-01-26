Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbbAZQMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:12:07 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:48445 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbbAZQME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:12:04 -0500
Message-ID: <54C66742.7000500@gmail.com>
Date: Mon, 26 Jan 2015 19:11:46 +0300
From: Dmitry Osipenko <digetx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Bob Mottram <bob.mottram@codethink.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c: tegra: Maintain CPU endianness
References: <1421756555-20266-1-git-send-email-digetx@gmail.com> <20150122074001.GB427@ulmo> <CAAVeFuJHST9VOWXe_cZNvLmfGdamuU4HSgdZC6EoQvrsGFt+Fg@mail.gmail.com> <54C115D1.10206@gmail.com> <54C12010.8040504@gmail.com> <54C130EA.2050505@gmail.com> <20150123094552.GD3835@ulmo> <54C24C2B.1070907@gmail.com> <54C2601A.7000005@gmail.com> <20150126160339.GD13494@katana>
In-Reply-To: <20150126160339.GD13494@katana>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

26.01.2015 19:03, Wolfram Sang пишет:
>
>> Gaahh! I'm sure it wasn't working before! I'll make more testing and send v3
>> without "val = 0", if all will be fine.
>
> Please either send V3 or explicitly say V2 is OK. No need to hurry, just
> saying that I am waiting for updates here...
>
Sure!

-- 
Dmitry
