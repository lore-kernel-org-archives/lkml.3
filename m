Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3ATLZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 06:25:19 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:46577 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3ATLZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 06:25:18 -0500
Message-ID: <50FBD413.1000406@xs4all.nl>
Date: Sun, 20 Jan 2013 12:25:07 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic> <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org>
In-Reply-To: <20130120111920.GL25591@8bytes.org>
X-Enigmail-Version: 1.5.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jörg,

On 2013-01-20 12:19, Jörg Rödel wrote:
> On Sun, Jan 20, 2013 at 11:40:20AM +0100, Udo van den Heuvel wrote:
>> Hello,
>>
>> On 2013-01-20 11:36, Borislav Petkov wrote:
>>> I know just the guy, CCed. :-)
>>
>> Thanks for the quick response!
>> I found this similar case:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1073384
> 
> Yes, this is a Hardware issue for which the BIOS does not apply the
> workaround.

Hardware issue? What is wrong c.q. happening?

I have this:

# dmesg|grep IOMMU
[    0.000000] ACPI: IVRS 000000009dd12420 00070 (v02  AMD   AMDIOMMU
00000001 AMD  00000000)
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    1.125636] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40

So kernel says I have no IOMMU but still one is found? (!?)

> The only solution for now is to disable the IOMMU on the
> Trinity based chips. 

In PC-BIOS I assume?
I did not yet find an option, but this is the first occurrence.
Can the BIOS vendor fix this? If so: please explain so I cna contact
Gigabyte (motherboard manufacturer)

> The question is what to do now, I tend to disable the IOMMU if a
> Trinity chip is detected. This is not the first report of this problem
> I encountered.

I know, see the URL I posted.
What is the impact of disabling the IOMMU?


Udo
