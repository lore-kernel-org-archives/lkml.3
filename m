Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3J1Im7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:42:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60982 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751848Ab3J1Im4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:42:56 -0400
Message-ID: <526E238B.2070900@free-electrons.com>
Date: Mon, 28 Oct 2013 09:42:51 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Lan Tianyu <lantianyu1986@gmail.com>, Len Brown <lenb@kernel.org>,
        rjw@rjwysocki.net,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: remove unused ACPI_PROCFS Kconfig param
References: <1382857012-2971-1-git-send-email-michael.opdenacker@free-electrons.com>	 <CAOLK0pxe0tsgo1+U8WT4-9cxTxS9MKaiGhLd2S-T-T7imPyd7A@mail.gmail.com>	 <526E0293.4080702@free-electrons.com> <1382948855.32195.9.camel@x220.thuisdomein>
In-Reply-To: <1382948855.32195.9.camel@x220.thuisdomein>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 10/28/2013 09:27 AM, Paul Bolle wrote:
> On Mon, 2013-10-28 at 07:22 +0100, Michael Opdenacker wrote:
>> [...] CONFIG_ACPI_PROCFS is no longer used anywhere, neither in
>> Makefiles nor in the source code. ACPI_PROCFS isn't event used in
>> Kconfig files as an intermediate dependency.
>>
>> What I deduce from that is that even if you set CONFIG_ACPI_PROCFS=y in
>> the kernel configuration, this will have no impact at all.
> About half a year ago I noticed that this Kconfig symbol is unused since
> v2.6.38 [0]. As, apparently, nothing has changed it is currently unused
> for over two and a half years.
>
> I still don't really understand the purpose of this symbol. But whatever
> it is, it might as well be dropped. If it's ever needed again it could
> be re-added. Or, perhaps, an entirely different approach could be used
> to accomplish what that symbol is supposed to do.
>
>
> Paul Bolle
>
> [0] http://marc.info/?l=linux-acpi&m=136398635322975
Good to know that nobody has complained about this for two and half
years :) This is then probably safe to remove this symbol for good.

Thanks again,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

