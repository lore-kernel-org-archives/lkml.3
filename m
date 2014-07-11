Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaGKHd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:33:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61971 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaGKHd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:33:26 -0400
X-AuditID: cbfee690-b7fb56d000003439-dd-53bf9343cab9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tanmay Inamdar'" <tinamdar@apm.com>,
        "'Liviu Dudau'" <Liviu.Dudau@arm.com>
Cc: "'Rob Herring'" <robherring2@gmail.com>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'linaro-kernel'" <linaro-kernel@lists.linaro.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Sinan Kaya'" <okaya@codeaurora.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Suravee Suthikulanit'" <suravee.suthikulpanit@amd.com>,
        "'Device Tree ML'" <devicetree@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <CAL_JsqK_CfagmiFOpOXVYGry22nGnCZL0ZXeJhYxb9zp=P2fsQ@mail.gmail.com>
 <20140708171828.GM6501@e106497-lin.cambridge.arm.com>
 <CACoXjcn3b7otcbxdr+RAVNHHjHyVsvw0QcmK5jd-QBF8SQX5iw@mail.gmail.com>
In-reply-to: <CACoXjcn3b7otcbxdr+RAVNHHjHyVsvw0QcmK5jd-QBF8SQX5iw@mail.gmail.com>
Subject: Re: [PATCH v8 0/9] Support for creating generic PCI host bridges from
 DT
Date: Fri, 11 Jul 2014 16:33:23 +0900
Message-id: <004501cf9cda$65703610$3050a230$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+coVXJ6D3BoZmXTR2ult6qu0iseAAOJmGg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t8zQ13nyfuDDd6s5bL4O+kYu8WHplZm
	iyVNGRbvl/UwWsw/co7V4tWZjWwWlxdeYrXoXXCVzeL9oWfMFpseX2O1uLxrDpvF2XnH2SwO
	LG1nsWictI3J4vu3b2wWE38sYLR4/ukTi8XLjydYHIQ8Wi/9ZfP4uP4To8eaeWsYPX7/msTo
	cbmvl8lj56y77B4LNpV69LxpYfXYvKTe4/a/x8wefVtWMXr8fKnj8XmTXABvFJdNSmpOZllq
	kb5dAlfGrUNvGQuOyFZcnPKJtYHxt1gXIyeHhICJREPDNxYIW0ziwr31bF2MXBxCAssYJe5f
	7mKHKzr4ixEisYhR4vyDi1DOb0aJQ6d2g7WzCahJfPlyGKxDRMBHYvXZ1ywgRcwCJ1glDv34
	zAzR0cEk8XXXBUaQKk6BYIkVm64CVXFwCAPZW+cbgYRZBFQlfv99CzaUV8BW4uO+6cwQtqDE
	j8n3wOLMAuoSk+YtYoawtSWevLvACjJGAij+6K8uxA1GEs+WbGKDKBGR2PfiHdjREgIfOCTO
	vVzJCLFLQOLb5EMsEL2yEpsOMEN8LClxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFy
	QXFSepGJXnFibnFpXrpecn7uJkZI2pmwg/HeAetDjMlA6ycyS4km5wPTVl5JvKGxmZGFqYmp
	sZG5pRlpwkrivGqPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MIau3DFDX9EnkPHapime
	hqsO9bldqT2046X/gVvM6Z4fzNmOfwk6MjXKIexys9kno/Ux7HzJmj8evlxtodw6KbRhunHl
	B+3Dux3dOpepvj6/5uUTh/Ypdz/dvb1tzpegRJ/7riduhLm9TZh7NfHgErujf1cHKv7mCt1t
	t1DqYPvNnSw7mk3S0zcrsRRnJBpqMRcVJwIAKZnxz1EDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsVy+t9jAV3nyfuDDQ4cY7H4O+kYu8WHplZm
	iyVNGRbvl/UwWsw/co7V4tWZjWwWlxdeYrXoXXCVzeL9oWfMFpseX2O1uLxrDpvF2XnH2SwO
	LG1nsWictI3J4vu3b2wWE38sYLR4/ukTi8XLjydYHIQ8Wi/9ZfP4uP4To8eaeWsYPX7/msTo
	cbmvl8lj56y77B4LNpV69LxpYfXYvKTe4/a/x8wefVtWMXr8fKnj8XmTXABvVAOjTUZqYkpq
	kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Qi0oKZYk5pUChgMTi
	YiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjFuH3jIWHJGtuDjlE2sD42+xLkZODgkBE4mG
	g78YIWwxiQv31rN1MXJxCAksYpQ4/+AiI4Tzm1Hi0KndLCBVbAJqEl++HGYHsUUEfCRWn33N
	AlLELHCCVeLQj8/MEB0dTBJfd10Am8spECyxYtNVoCoODmEge+t8I5Awi4CqxO+/b8GG8grY
	SnzcN50ZwhaU+DH5HlicWUBdYtK8RcwQtrbEk3cXWEHGSADFH/3VhbjBSOLZkk1sECUiEvte
	vGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgpPaM+kd
	jKsaLA4xCnAwKvHwnlizL1iINbGsuDL3EKMEB7OSCO+T+v3BQrwpiZVVqUX58UWlOanFhxhN
	gR6dyCwlmpwPTLh5JfGGxiZmRpZGZhZGJubmSuK8B1utA4UE0hNLUrNTUwtSi2D6mDg4pRoY
	ix918tleMRIK0fkkxn7g0bfn6h+ZVy8/va1dqMPc9vq0g8urJppdY2XvCT+dqHRifVjVLMWf
	9+YlfNHzrnVXypozK2jb/0tNwe1SZ09Iihl/lubPPa1Q9unFshaduzHSXx9mamVaHZzYdn+l
	Zdu5y/WsdjPWSjyey6rmVr5c4fOH5L8npaJClFiKMxINtZiLihMBjruw0IADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 11, 2014 9:44 AM, Tanmay Inamdar wrote:
> On Tue, Jul 8, 2014 at 10:18 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > On Sun, Jul 06, 2014 at 04:23:43PM +0100, Rob Herring wrote:
> >> On Tue, Jul 1, 2014 at 1:43 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> >> > This is my resurected attempt at adding support for generic PCI host
> >> > bridge controllers that make use of device tree information to
> >> > configure themselves. I've tagged it as v8 although the patches
> >> > have now been reshuffled in order to ease adoption so referring to
> >> > the older versions might be a bit of a hoop jumping exercise.
> >> >
> >> > Changes from v7:
> >> >   - Reordered the patches so that fixes and non-controversial patches
> >> >     from v7 can be accepted more easily. If agreed I can split the
> >> >     series again into patches that can be upstreamed easily and ones
> >> >     that still need discussion.
> >> >   - Moved the of_create_host_bridge() function to drivers/of/of_pci.c
> >> >     to better reflect its target use.
> >> >   - Added the function to remap the bus I/O resources that used to be
> >> >     provided in my arm64 patch series and (re)named it pci_remap_iospace()
> >> >   - Removed error code checking from parsing and mapping of IRQ from DT
> >> >     in recognition that some PCI devices will not have legacy IRQ mappings.
> >> >
> >> > v7 thread here with all the historic information: https://lkml.org/lkml/2014/3/14/279
> >>
> >> Can you publish a branch for this series please.
> >>
> >> Rob
> >>
> >
> > Hi Rob,
> >
> > I have pushed a brach that matches my v8 patchset +1 obvious missing header include
> > here: http://www.linux-arm.org/git?p=linux-ld.git;a=shortlog;h=refs/heads/for-upstream/pci_v8
> >
> 
> I was still getting following compilation error after applying arm64
> pci headers. Please let me know if I am missing something.
> 
> linux-git/drivers/of/of_pci.c: In function ‘pci_host_bridge_of_get_ranges’:
> linux-git/drivers/of/of_pci.c:114:22: error: storage size of ‘range’ isn’t known
>   struct of_pci_range range;
>                       ^
> linux-git/drivers/of/of_pci.c:115:29: error: storage size of ‘parser’
> isn’t known
>   struct of_pci_range_parser parser;
>                              ^
> linux-git/drivers/of/of_pci.c:121:2: error: implicit declaration of
> function ‘of_pci_range_parser_init’
> [-Werror=implicit-function-declaration]
>   err = of_pci_range_parser_init(&parser, dev);
> 
> 
> Below patch fixes the errors.
> 
> diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> index 55d8320..da88dac 100644
> --- a/drivers/of/of_pci.c
> +++ b/drivers/of/of_pci.c
> @@ -2,6 +2,7 @@
>  #include <linux/export.h>
>  #include <linux/of.h>
>  #include <linux/of_pci.h>
> +#include <linux/of_address.h>

Yes, right. I also found the build errors as above mentioned.
"of_address.h" should be included, in order to fix the build errors.
However, for readability, the following would be better.

 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_pci.h>

Best regards,
Jingoo Han

> 
>  static inline int __of_pci_pci_compare(struct device_node *node,
>                                        unsigned int data)
> 
> 
> > Best regards,
> > Liviu
> >
> >
> > --
> > ====================
> > | I would like to |
> > | fix the world,  |
> > | but they're not |
> > | giving me the   |
> >  \ source code!  /
> >   ---------------
> >     ¯\_(ツ)_/¯
> >

