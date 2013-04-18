Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967634Ab3DRQaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:30:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56291 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966421Ab3DRQaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:30:23 -0400
Message-ID: <51701F6F.7070206@ti.com>
Date: Thu, 18 Apr 2013 19:29:35 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <t-kristo@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC v1] regulator: core: introduce regulator chain locking scheme
References: <1366031015-17073-1-git-send-email-grygorii.strashko@ti.com> <1366031015-17073-2-git-send-email-grygorii.strashko@ti.com> <20130415155040.GD15837@opensource.wolfsonmicro.com> <516C2905.8000200@ti.com> <20130415164018.GA14064@sirena.org.uk>
In-Reply-To: <20130415164018.GA14064@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.172]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 07:40 PM, Mark Brown wrote:
> On Mon, Apr 15, 2013 at 07:21:25PM +0300, Andrii Tseglytskyi wrote:
>> On 04/15/2013 06:50 PM, Mark Brown wrote:
>>>> In addition, such locking scheme allows to have access to the supplier
>>>> regulator API from inside child's (consumer) regulator API.
>>> I've still not seen any use case articulated for doing this...
>> Use case is introduced in ABB series:
> Sorry, I meant any sensible use case.
Hi Mark,

Thanks for you comments. I'll split it to 3 patches:
- abstract locking out into helper functions;
- introduce regulator chain locking scheme
- allow reentrant calls into the regulator framework (with hope that is 
has future,
may be can enable/disable it through constraints)

I understand that Regulator FW is common and wide used and we should 
very careful here.

Regards,
- grygorii
