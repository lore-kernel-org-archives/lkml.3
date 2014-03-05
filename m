Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaCEQMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:12:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbaCEQMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:12:50 -0500
From: Thomas Renninger <trenn@suse.de>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Moore, Robert" <robert.moore@intel.com>,
        "Box, David E" <david.e.box@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "ck@conrad-kostecki.de" <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "devel@acpica.org" <devel@acpica.org>
Subject: Re: [PATCH 2/4] ACPICA: Introduce new acpi_os_physical_table_add OS callback
Date: Wed, 05 Mar 2014 17:12:46 +0100
Message-ID: <2930767.eZaJX0jVGm@skinner>
User-Agent: KMail/4.11.4 (Linux/3.11.6-4-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88024BDA9C@SHSMSX101.ccr.corp.intel.com>
References: <1393608241-31037-1-git-send-email-trenn@suse.de> <1393960620.uGzzRHqAbc@skinner> <1AE640813FDE7649BE1B193DEA596E88024BDA9C@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 05, 2014 06:26:54 AM Zheng, Lv wrote:
... 
> > > After the table manager cleanups are tested and shipped in the ACPICA
> > > repo,
> > > the new facilities will automatically be rolled into Linux branches.
> > 
> > I'd suggest to just wait for that.
> > Best already try to integrate the ACPI table override/add part as you
> > think
> > it should work without additional changes in drivers/acpi/acpica.
> > 
> > If this happened and things are submitted to get integrated into the Linux
> > kernel, please add me to CC or point me to the patchset.
> 
> Fortunately, there is a kernel bugzilla entry requires this series.
> I've posted it on the kernel bugzilla.
> Here is the patchset:
> https://bugzilla.kernel.org/show_bug.cgi?id=69711
> You need to apply 9 patches:
> attachment 128061 - attachment 128141
> The last patch has introduced an early boot API:
> acpi_install_table.
> This can be used to enhance this series.

Ok, thanks.
Be aware that I am super busy right now. This week is impossible,
I cannot promise when I will have time for that.

      Thomas
