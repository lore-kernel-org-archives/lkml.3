Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaKRTyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:54:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59669 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753829AbaKRTyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:54:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jon Masters <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        Kangkang.Shen@huawei.com, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v5 03/18] ACPI / table: Count matched and successfully parsed entries without specifying max entries
Date: Tue, 18 Nov 2014 21:15:43 +0100
Message-ID: <7743567.TJcygJtKD3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <546B4EDD.9050804@linaro.org>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <1413553034-20956-4-git-send-email-hanjun.guo@linaro.org> <546B4EDD.9050804@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 18, 2014 09:51:25 PM Hanjun Guo wrote:
> Hi Rafael,
> 
> On 2014年10月17日 21:36, Hanjun Guo wrote:
> > From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> >
> > It is very useful to traverse all available table entries without max
> > number of expected entries type. Current acpi_parse_entries()
> > implementation gives that feature but it does not count those entries,
> > it returns 0 instead, so fix it to count matched and successfully
> > entries and return it.
> >
> > NOTE: This change has no impact to x86 and ia64 archs since existing code
> > checks for error occurrence only (acpi_parse_entries(...,0) < 0).
> >
> > Acked-by: Grant Likely <grant.likely@linaro.org>
> > Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> > Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> 
> Patch 2 and patch 3 are only for ACPI cores, and have no harm to x86
> and IA64, could you merge first in 3.19?

I can do that if that helps.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
