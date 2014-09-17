Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbaIQXGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 19:06:20 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53463 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264AbaIQXGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 19:06:16 -0400
Message-ID: <541A13E3.4010800@linaro.org>
Date: Thu, 18 Sep 2014 07:06:11 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <4416582.iOjLNrLDZE@vostro.rjw.lan> <20140917192259.GA18980@srcf.ucam.org> <1628662.T2ReQ4irMm@vostro.rjw.lan>
In-Reply-To: <1628662.T2ReQ4irMm@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月18日 04:11, Rafael J. Wysocki wrote:
> On Wednesday, September 17, 2014 08:22:59 PM Matthew Garrett wrote:
>> On Wed, Sep 17, 2014 at 09:37:42PM +0200, Rafael J. Wysocki wrote:
>>
>>> There are no implied IP issues with using the information there I know of and
>>> if there's any fine print anywhere that may suggest so, please let me know.
>> Using the information should be fine, but my understanding of the UEFI 
>> forum rules is that any submissions to UEFI specs must be from UEFI 
>> forum members - there are concerns around accidentally including 
>> patented material.
> The documents in question are not regarded as UEFI specs, however.  They
> are just hosted by UEFI.
>
>> The easy way around this is just for the bindings to 
>> be managed outside UEFI.
> Again, there's a difference between UEFI material and the UEFI hosting
> something (but not maintaining it).
>
> In principle, the bindings could be hosted by UEFI, but maintained by
> community members.

Thanks for the clarify, I totally agree with you, that's how things work now for such doc hosted
by UEFI.

For now,  _DSD will use the same binding as DT, is there any chance that _DSD will introduce
new bindings? if yes, how can we handle it?

Thanks
Hanjun
