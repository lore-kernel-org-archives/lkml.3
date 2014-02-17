Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaBQTnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:43:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32849 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221AbaBQTnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:43:02 -0500
Message-ID: <530265A3.3020302@zytor.com>
Date: Mon, 17 Feb 2014 11:40:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, devel@acpica.org
Subject: Re: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <1678556.oPQNyVF84j@skinner> <53025956.40505@zytor.com> <4233973.R9Tf84J4Ne@skinner>
In-Reply-To: <4233973.R9Tf84J4Ne@skinner>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 11:25 AM, Thomas Renninger wrote:
> On Monday, February 17, 2014 10:47:50 AM H. Peter Anvin wrote:
>> On 02/17/2014 10:23 AM, Thomas Renninger wrote:
>>> Easiest I can think of instead of trying to modify RSDP or similar, is
>>> to still pass the tables via unzipped, glued cpio which the kernel
>>> can access early. The same way it is done for current ACPI table
>>> overriding
>>> and early microcode passing.
>>
>> We shouldn't *need* an RSDP and RSDT/XSDT, though, since all they are
>> are pointers to the actual tables.  Rather than hacking around it we
>> should probably just fix the fundamental problem.
> 
> That is what I described.
> If something similar what I wrote gets implemented, you can simply
> add ACPI tables to initrd as described here:
> Documentation/acpi/initrd_table_override.txt
> and if BIOS already provides them they get overridden, otherwise
> they get added.
> 

Right, that was the idea.  Thomas Gleixner said it didn't work.

	-hpa


