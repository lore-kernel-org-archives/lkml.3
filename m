Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbbAEXIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:08:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56581 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752714AbbAEXIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:08:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acpi: acpica: utstate:  Remove unused function
Date: Tue, 06 Jan 2015 00:30:20 +0100
Message-ID: <3056635.sprz8UnhD7@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88026AACAC@SHSMSX101.ccr.corp.intel.com>
References: <1420232480-3252-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <1AE640813FDE7649BE1B193DEA596E88026AACAC@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 05, 2015 08:39:37 AM Zheng, Lv wrote:
> Hi, Richard
> 
> > From: Rickard Strandqvist [mailto:rickard_strandqvist@spectrumdigital.se]
> > Sent: Saturday, January 03, 2015 5:01 AM
> > 
> > Remove the function acpi_ut_create_pkg_state_and_push() that is not used anywhere.
> > 
> > This was partially found by using a static code analysis program called cppcheck.
> 
> acpi_ut_create_pkg_state_and_push() is not even used in ACPICA.
> We can remove it now.

Let's first remove it in upstream ACPICA, then, I suppose.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
