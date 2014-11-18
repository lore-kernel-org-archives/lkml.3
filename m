Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbaKRQne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:43:34 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60419 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaKRQnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:43:31 -0500
Date: Tue, 18 Nov 2014 16:43:13 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "Kangkang.Shen@huawei.com" <Kangkang.Shen@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v5 01/18] ARM64: Move the init of cpu_logical_map(0)
 before unflatten_device_tree()
Message-ID: <20141118164312.GL28279@e104818-lin.cambridge.arm.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <1413553034-20956-2-git-send-email-hanjun.guo@linaro.org>
 <546B4D8D.2020605@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546B4D8D.2020605@linaro.org>
Thread-Topic: [PATCH v5 01/18] ARM64: Move the init of cpu_logical_map(0)
 before unflatten_device_tree()
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 01:45:49PM +0000, Hanjun Guo wrote:
> On 2014年10月17日 21:36, Hanjun Guo wrote:
> > It always make sense to initialize CPU0's logical map entry from the
> > hardware values, so move the initialization of cpu_logical_map(0)
> > before unflatten_device_tree() which is needed by ACPI code later.
> >
> > Acked-by: Olof Johansson <olof@lixom.net>
> > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> 
> Could you merge this patch first in 3.19? It was acked by Olof and
> Mark, and it will make sense without ACPI too.

I think it can go in for 3.19 (it's Will's turn this time ;)).

FWIW:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
