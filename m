Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab3EHPVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:21:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41142 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab3EHPU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:20:59 -0400
Message-ID: <518A6D3F.4040405@zytor.com>
Date: Wed, 08 May 2013 08:20:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, fenghua.yu@intel.com, xen-devel@lists.xensource.com
Subject: Re: v3.9 - CPU hotplug and microcode earlier loading hits a mutex
 deadlock (x86_cpu_hotplug_driver_mutex)
References: <20130506125937.GA14036@phenom.dumpdata.com> <20130507190024.GA4303@phenom.dumpdata.com> <20130508125414.GB30955@pd.tnic> <20130508140342.GA8152@phenom.dumpdata.com> <20130508142949.GC30955@pd.tnic>
In-Reply-To: <20130508142949.GC30955@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 07:29 AM, Borislav Petkov wrote:
> On Wed, May 08, 2013 at 10:03:42AM -0400, Konrad Rzeszutek Wilk wrote:
> 
> [ … snip some funky BIOS code ]
> 
>> [here it shifts and continues on testing each CPU bit]
>>
>>> Questions over questions...?
>>
>> I probably went overboard with my answers :-)
> 
> Konrad, you're killing me! :-) You actually went and looked at the
> BIOS disassembly voluntarily. You must be insane, I think you should
> immediately go to the doctor now for a thorough checkup. :-)
> 
> I think I know who I can sling BIOS issues now to.
> 

Nah, that was just the ACPI AML.  Real BIOS code is much scarier.

	-hpa

