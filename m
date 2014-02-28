Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaB1R1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:27:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbaB1R1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:27:05 -0500
From: Thomas Renninger <trenn@suse.de>
To: robert.moore@intel.com
Cc: lv.zheng@intel.com, david.e.box@intel.com, rafael.j.wysocki@intel.com,
        hpa@zytor.com, tglx@linutronix.de, ck@conrad-kostecki.de,
        linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
        rjw@rjwysocki.net, devel@acpica.org
Subject: Re: [PATCH 1/4] ACPI: Provide support for ACPI table adding via OS
Date: Fri, 28 Feb 2014 18:27 +0100
Message-ID: <2497462.Z4USttrz7C@skinner>
User-Agent: KMail/4.11.4 (Linux/3.11.6-4-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1393608241-31037-2-git-send-email-trenn@suse.de>
References: <1393608241-31037-1-git-send-email-trenn@suse.de> <1393608241-31037-2-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest changes are compile tested only!

If this gets serialized/merged and accepted in acpica in
some form with whatever other stuff currently added,
please drop me a mail.

I can then submit the Linux parts again to the kernel people
with the documentation adjusted as well:
Documentation/acpi/initrd_table_override.txt

Thanks,

     Thomas
