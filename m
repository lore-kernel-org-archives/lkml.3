Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbbAEXIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:08:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60818 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752714AbbAEXIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:08:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acpi: acpica: utmisc.c:  Remove unused function
Date: Tue, 06 Jan 2015 00:30:56 +0100
Message-ID: <1648651.DmmjNgUaYH@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88026AAC8D@SHSMSX101.ccr.corp.intel.com>
References: <1420132554-32049-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <1AE640813FDE7649BE1B193DEA596E88026AAC8D@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 05, 2015 08:32:59 AM Zheng, Lv wrote:
> Hi, Rickard
> 
> > From: Rickard Strandqvist [mailto:rickard_strandqvist@spectrumdigital.se]
> > Sent: Friday, January 02, 2015 1:16 AM
> > 
> > Remove the function acpi_ut_is_aml_table() that is not used anywhere.
> 
> This function is used by the ACPICA debugger and disassembler.
> The ACPICA release process has just automatically released this function from the ACPICA code base to the Linux kernel.
> 
> We shouldn't just remove it from the Linux kernel code base.
> If we do so, it's just turned into divergences that can hurt the release automation.
> You may use ACPI_FUTURE_USAGE around these functions instead.

Can we do that in upstream ACPICA?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
