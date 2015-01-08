Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbbAHUB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 15:01:26 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:10521 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbAHUBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 15:01:24 -0500
From: Kangkang Shen <Kangkang.Shen@huawei.com>
To: Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>
CC: Rob Herring <robh@kernel.org>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Richter <rric@kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "Jon Masters" <jcm@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lv Zheng <lv.zheng@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>
Subject: RE: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
Thread-Topic: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
Thread-Index: AQHQKOlVlUckDowSXkSLjn8E6OKNrpyxcQwAgAD8cYCAAFUigIAAMWqAgAAuAoCAAHJ5AIAAXxGAgAAUzICAABUuAIAASPyAgAAUwQCAABVxAIAAAdMAgAAwkgCAANDygIABEXLQ
Date: Thu, 8 Jan 2015 19:59:23 +0000
Message-ID: <9A6BBCC9BB211F40A86BE42635C3C534712FA4C6@szxeml555-mbx.china.huawei.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <54AD917A.2040307@redhat.com> <20150107225904.GQ24989@titan.lakedaemon.net>
 <2034224.H5nZdW12se@wuerfel>
In-Reply-To: <2034224.H5nZdW12se@wuerfel>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.35.101]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.54AEE1AD.024A,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=169.254.1.70,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 17873e317ddddc4ff1aacab97a7c0117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Security is a much big scale issue. The industry has all kind of solutions to deal with firmware security. In ARM system, the Firmware has been designed with higher privilege/security than OS. I will suggest we trust firmware security and focus on Linux itself.  

-----Original Message-----
From: linaro-acpi-bounces@lists.linaro.org [mailto:linaro-acpi-bounces@lists.linaro.org] On Behalf Of Arnd Bergmann
Sent: Thursday, January 08, 2015 3:27 AM
To: Jason Cooper
Cc: Rob Herring; Daniel Lezcano; Robert Richter; linaro-acpi@lists.linaro.org; Marc Zyngier; Jon Masters; Randy Dunlap; Liviu Dudau; Robert Moore; Will Deacon; linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org; Mark Brown; Rafael J. Wysocki; Lv Zheng; Catalin Marinas; Bjorn Helgaas; linux-arm-kernel@lists.infradead.org; Olof Johansson
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64

On Wednesday 07 January 2015 17:59:04 Jason Cooper wrote:
> On Wed, Jan 07, 2015 at 03:05:14PM -0500, Jon Masters wrote:
> > On 01/07/2015 02:58 PM, Jon Masters wrote:
> > > On 01/07/2015 01:41 PM, Jason Cooper wrote:
> > 
> > >> One of the reasons I've really enjoyed working with ARM platforms 
> > >> and DT is the absence of this type of 'feature'.  I honestly 
> > >> don't care whether the kernel gets the board configuration info 
> > >> from DT or ACPI or FOO, as long as we can avoid the security mistakes of the past:
> > >>
> > >>   
> > >> http://www.spiegel.de/international/world/catalog-reveals-nsa-has
> > >> -back-doors-for-numerous-devices-a-940994.html
> > > 
> > > ACPI is not the great satan. I'm aware certain others in the 
> > > community have written missinformed blog posts and G+ rants 
> > > equating ACPI with SMI and even with various other system 
> > > firmware. I can't force someone to become informed on a topic, 
> > > especially if it's politically useful to them to hate on ACPI and use the security paranoia handwavy argument.
> > 
> > To clarify, and this is not directed at you Jason, it is politically 
> > useful to some who have written rants those business models are 
> > built upon being paid to enable platforms. For those folks, 
> > standardized platforms which allow a common OS approach are seen as threatening.
> 
> Ahh, thanks for clarifying.
> 
> > In the previous rants (which were really instigated as a result of 
> > the
> > above) ACPI was equated with SMM (System Management Mode), which is 
> > a bit like the Secure/Trusted world on AArch64 in which you might 
> > run another "Trusted" OS. These are the places where you want to 
> > watch out to malware of the kind cited in your link, not in ACPI tables.
> 
> fwiw, I *am* concerned about those spaces.  It seems we agree on their 
> vulnerability to attack (plus being meaty targets).
> 
> To more concisely state my other reply to you, wrt to AML, I'm 
> primarily concerned about a malicious update to the ACPI tables.  The 
> ACPI tables in the update would be otherwise normal, except for the 
> AML blob that contains some extra code.  The malicious payload.  Then, 
> a routine call into an AML (for pinctrl, say) executes the malicious code.
> 
> The plausibility and preventability of that style of attack is what 
> I'm hoping to nail down with this discussion.

If you want to run hidden code through the firmware, then doing an attack on Intel SMM or ARM TrustZone would be much harder to detect and as easy to get in, as long as you have the ability to flash arbitrary firmware.
I think this has been shown to happen in the wild. That code could go and manipulate the running kernel image to do something else.

Running code inside of the AML interpreter is fairly limited for the purpose of an attack [*], but there might be bugs in the interpreter that allow arbitrary code execution from malicious firmware. I think this case would be similar to constructing a malicious DT blob that exploits a bug in the DT parser for arbitrary code execution. The AML interpreter is a relatively large chunk of code, but it's self-contained. In comparison, the DT parser is much smaller, but has the additional
(theoretical) problem of potential buffer overflows in any drivers that use it incorrectly (e.g. format string attacks on string properties).
Another difference is that the AML code is intended to not be user-upgradable without a full firmware upgrade, while a DT blob is meant to be easily replaced if necessary without flashing the firmware, using the same permissions you need for updating the OS.

I'm deliberately not trying to draw conclusions regarding whether AML is more or less secure than DT, but the above is my understanding of the fundamental differences.

	Arnd

[*] I would assume you can get AML code to write to arbitrary physical memory locations without much effort, but it has rather limited arithmetical capabilities which makes it hard to know where to write to.

_______________________________________________
Linaro-acpi mailing list
Linaro-acpi@lists.linaro.org
http://lists.linaro.org/mailman/listinfo/linaro-acpi
