Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbaCCMl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 07:41:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbaCCMlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 07:41:55 -0500
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
Date: Mon, 03 Mar 2014 13:41:52 +0100
Message-ID: <2330411.KHkNc5Vvtq@skinner>
User-Agent: KMail/4.11.4 (Linux/3.11.6-4-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88024BB021@SHSMSX101.ccr.corp.intel.com>
References: <1393608241-31037-1-git-send-email-trenn@suse.de> <1393608241-31037-3-git-send-email-trenn@suse.de> <1AE640813FDE7649BE1B193DEA596E88024BB021@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lv,

On Monday, March 03, 2014 01:20:31 AM Zheng, Lv wrote:
> Hi, Thomas
> 
> I have a patch series that can cleanup the ACPICA table manager, and change
> the acpi_load_table into the following style:

Ok. I suggest that:
1) If Thomas (Gleixner) or whoever wants to try out or needs it urgently, he
   can (must) use a recent kernel with my patches applied.
2) You continue to get your changes into ACPICA.
   Eventually or best would be if you add whatever is needed to
   allow adding of tables as well (which will be there automatically if
   I understood the description of your changes correctly).
3) Either you give it a try yourself or give me short description for 
   what I have to look out for and I can re-post the Linux patches
   based on your ACPICA changes, once they show up in the Linux kernel.
   Best give me a ping as soon as I should look at it.

Thanks!

  Thomas

PS: You might want to add the BGRT definition in ACPICA already, the
    tiny one line-liner...
