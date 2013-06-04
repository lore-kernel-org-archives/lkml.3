Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3FDNgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:36:05 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:56297 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3FDNgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:36:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130604132322.GA10933@srcf.ucam.org>
References: <cover.1348652044.git.lv.zheng@intel.com> <09ee0e9c79c57da2fc9d0af1c2daeaacdc0bb234.1349838218.git.lv.zheng@intel.com>
 <20121010174406.GA13861@srcf.ucam.org> <1350069843.7065.65.camel@rhapsody>
 <CACxGe6tC+=98uD=Oc=u-=NHzVKgG9r_3eg+-sG-DQYUnCGw0sA@mail.gmail.com> <20130604132322.GA10933@srcf.ucam.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 4 Jun 2013 14:35:39 +0100
X-Google-Sender-Auth: spB7tk2WzEZ9unA_3zu_4rf2Gzw
Message-ID: <CACxGe6vYKq0QpeXHzgMabjkY4x9rVbm7OpXs6boAntVvPK=vrA@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] ACPI: Add early console framework for DBGP/DBG2.
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Khalid Aziz <khalid@gonehiking.org>, Matthew Garrett <mjg@redhat.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Feng Tang <feng.tang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, Al Stone <al.stone@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 2:23 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jun 04, 2013 at 11:53:56AM +0100, Grant Likely wrote:
>
>> Matthew, can you point me at the license Microsoft is using for the
>> DBG2 table? I can download the document from Microsoft's site without
>> seeing any reference to it being licensed only for BIOS implementers.
>> All I see is a "this document is provided 'as-is', blah blah blah"
>> blurb at the beginning of the document. It may be that Microsoft has
>> changed the license on this document in the last 6 months.
>
> The DBGP spec still seems to have the restrictive license, but I can't
> find it on DBG2.

Thanks Matthew. I'll follow up with Microsoft on DBGP.

g.
