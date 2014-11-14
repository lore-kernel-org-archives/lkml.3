Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422871AbaKNXOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:14:16 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56217 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422798AbaKNXOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:14:15 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 3/3] ACPI / processor: Rename acpi_(un)map_lsapic() to acpi_(un)map_cpu()
Date: Sat, 15 Nov 2014 00:35:14 +0100
Message-ID: <1820875.eppNBckBcQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <10283319.F5QMI6fbWn@vostro.rjw.lan>
References: <1414662780-2147-1-git-send-email-hanjun.guo@linaro.org> <5452CE9D.6000403@linaro.org> <10283319.F5QMI6fbWn@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 31, 2014 11:55:46 PM Rafael J. Wysocki wrote:
> On Friday, October 31, 2014 07:49:49 AM Hanjun Guo wrote:
> > On 2014年10月31日 04:12, Rafael J. Wysocki wrote:
> > > On Thursday, October 30, 2014 05:53:00 PM Hanjun Guo wrote:
> > >> acpi_map_lsapic() will allocate a logical CPU number and map it to
> > >> physical CPU id (such as APIC id) for the hot-added CPU, it will also
> > >> do some mapping for NUMA node id and etc, acpi_unmap_lsapic() will
> > >> do the reverse.
> > >>
> > >> We can see that the name of the function is a little bit confusing and
> > >> arch dependent so rename them as acpi_(un)map_map() to make arch
> > >
> > > That's acpi_(un)map_cpu() I guess?
> > 
> > ah, yes, typos, it should be acpi_(un)map_cpu(), my fault.
> > should I send another version?
> 
> No, I can fix this up.

I've queued up the series for 3.19, thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
