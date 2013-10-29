Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3J2Fvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 01:51:40 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59245 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab3J2Fvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 01:51:36 -0400
MIME-Version: 1.0
In-Reply-To: <1382948855.32195.9.camel@x220.thuisdomein>
References: <1382857012-2971-1-git-send-email-michael.opdenacker@free-electrons.com>
	<CAOLK0pxe0tsgo1+U8WT4-9cxTxS9MKaiGhLd2S-T-T7imPyd7A@mail.gmail.com>
	<526E0293.4080702@free-electrons.com>
	<1382948855.32195.9.camel@x220.thuisdomein>
Date: Tue, 29 Oct 2013 13:51:35 +0800
Message-ID: <CAOLK0pwPZt+Dr-TLa2tKaaKNYf6ArhmGFyhPqWSf8PT8oRDwuw@mail.gmail.com>
Subject: Re: [PATCH] ACPI: remove unused ACPI_PROCFS Kconfig param
From: Lan Tianyu <lantianyu1986@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Len Brown <lenb@kernel.org>, rjw@rjwysocki.net,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/28 Paul Bolle <pebolle@tiscali.nl>:
> On Mon, 2013-10-28 at 07:22 +0100, Michael Opdenacker wrote:
>> [...] CONFIG_ACPI_PROCFS is no longer used anywhere, neither in
>> Makefiles nor in the source code. ACPI_PROCFS isn't event used in
>> Kconfig files as an intermediate dependency.
>>
>> What I deduce from that is that even if you set CONFIG_ACPI_PROCFS=y in
>> the kernel configuration, this will have no impact at all.
>
> About half a year ago I noticed that this Kconfig symbol is unused since
> v2.6.38 [0]. As, apparently, nothing has changed it is currently unused
> for over two and a half years.
>
> I still don't really understand the purpose of this symbol. But whatever
> it is, it might as well be dropped. If it's ever needed again it could
> be re-added. Or, perhaps, an entirely different approach could be used
> to accomplish what that symbol is supposed to do.

I prefer the later. I will add new sysfs interface for LID status and make
all proc related code in the /driver/acpi/button.c under CONFIG_ACPI_PROCFS.

>
>
> Paul Bolle
>
> [0] http://marc.info/?l=linux-acpi&m=136398635322975
>



-- 
Best regards
Tianyu Lan
