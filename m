Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542AbaEFBKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:10:54 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:52759 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452AbaEFBKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:10:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140505192344.GL22111@sirena.org.uk>
References: <1399185156-521-1-git-send-email-swingboard@gmail.com> <20140505192344.GL22111@sirena.org.uk>
From: Barry Song <baohua@kernel.org>
Date: Tue, 6 May 2014 09:10:32 +0800
X-Google-Sender-Auth: xzCKwIAykfFSLcn9JSGKTer-cjo
Message-ID: <CAGsJ_4zN6mpa1_auXAiV5RsEPkgB7924MDZvfvh5AqGgZAizgw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] spi: sirf: decrease the interrupt count and
 latency of PIO mode
To: Mark Brown <broonie@kernel.org>
Cc: Qipan Li <swingboard@gmail.com>, linux-spi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Qipan Li <Qipan.Li@csr.com>, Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-06 3:23 GMT+08:00 Mark Brown <broonie@kernel.org>:
> On Sun, May 04, 2014 at 02:32:36PM +0800, Qipan Li wrote:
>> From: Qipan Li <Qipan.Li@csr.com>
>>
>> current PIO tranfer method be described as follows:
>
> I'm missing patch 1 here.

this is a follow of "[PATCH 2/2] spi: sirf: decrease the interrupt
count and latency of PIO mode", as you have applied 1/2 - [PATCH 1/2]
spi: sirf: refactor spi transfer functions, so there is no patch 1/2
here.
qipan made a typo , this should be directly a patch but not a 2/2. so
pls take it as a separate patch.

-barry
