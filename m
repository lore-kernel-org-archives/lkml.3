Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab3HNK5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:57:21 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:43332 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab3HNK5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:57:17 -0400
Message-ID: <520B6282.6030906@linux.vnet.ibm.com>
Date: Wed, 14 Aug 2013 16:27:06 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic> <20130812083355.47c1bae8@samsung.com> <5208D80D.5030206@linux.vnet.ibm.com> <20130812125343.GE18018@pd.tnic> <520A16BD.30201@linux.vnet.ibm.com> <20130813124258.GC4077@pd.tnic> <520A6D98.9060204@linux.vnet.ibm.com> <20130813175809.GE4077@pd.tnic>
In-Reply-To: <20130813175809.GE4077@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081410-5490-0000-0000-000003FC51C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 11:28 PM, Borislav Petkov wrote:
> On Tue, Aug 13, 2013 at 11:02:08PM +0530, Naveen N. Rao wrote:
>> If I'm not mistaken, even for systems that have EDAC drivers, it looks
>> to me like EDAC can't really decode to the DIMM given what is provided
>> by the bios in the APEI report currently. If and when ghes_edac gains
>> this capability, users will have a choice between raw APEI reports vs.
>> edac processed ones.
>
> Which kinda makes that APEI tracepoint not really useful and we can call
> the one we have already - trace_mc_event - from APEI...

This looks like a nice option. Mauro, what do you think?


Thanks,
Naveen

