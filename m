Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3FDKyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 06:54:19 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59644 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3FDKyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 06:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <1350069843.7065.65.camel@rhapsody>
References: <cover.1348652044.git.lv.zheng@intel.com> <09ee0e9c79c57da2fc9d0af1c2daeaacdc0bb234.1349838218.git.lv.zheng@intel.com>
 <20121010174406.GA13861@srcf.ucam.org> <1350069843.7065.65.camel@rhapsody>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 4 Jun 2013 11:53:56 +0100
X-Google-Sender-Auth: NelevAu5TPejcfrm6Ulz_qdAOUc
Message-ID: <CACxGe6tC+=98uD=Oc=u-=NHzVKgG9r_3eg+-sG-DQYUnCGw0sA@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] ACPI: Add early console framework for DBGP/DBG2.
To: Khalid Aziz <khalid@gonehiking.org>
Cc: Matthew Garrett <mjg@redhat.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Feng Tang <feng.tang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, Al Stone <al.stone@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 8:24 PM, Khalid Aziz <khalid@gonehiking.org> wrote:
> On Wed, 2012-10-10 at 18:44 +0100, Matthew Garrett wrote:
>> On Wed, Oct 10, 2012 at 11:23:01AM +0800, Lv Zheng wrote:
>> > Microsoft Debug Port Table (DBGP or DBG2) is used by the Windows SoC
>> > platforms to describe their debugging facilities.
>> > DBGP: http://msdn.microsoft.com/en-us/windows/hardware/hh134821
>> > DBG2: http://msdn.microsoft.com/en-us/library/windows/hardware/hh673515
>>
>> The license for these specifications only covers BIOS implementations,
>> not OS implementations. Has this had appropriate legal review?
>>
>
> I agree with Matthew. There are potential legal issues with using
> DBGP/DBGP2 tables in Linux. I had added support for SPCR and DBGP tables
> many years ago (in early 2.6 kernel timeframe) before Microsoft added
> this new license. I pulled the code out (in 2.6.14, I think) after
> Microsoft added the new license to these tables. I agree with Matthew's
> interpretation that the license is clear only about BIOS vendors being
> allowed to use these tables. PCDP table in DIG64 spec was introduced to
> get around the legal issues with using SPCR and DBGP in Linux.
>
> License for DBGP/DBGP2 needs some legal review before this patch can go
> into Linux.

Matthew, can you point me at the license Microsoft is using for the
DBG2 table? I can download the document from Microsoft's site without
seeing any reference to it being licensed only for BIOS implementers.
All I see is a "this document is provided 'as-is', blah blah blah"
blurb at the beginning of the document. It may be that Microsoft has
changed the license on this document in the last 6 months.

I asked some of my contacts at Microsoft about this and was told that
the DBG2 spec was supposed to be freed up; but I wasn't able to get
anything absolutely confirmed or in writing.

g.
