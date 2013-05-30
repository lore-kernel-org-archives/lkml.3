Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967787Ab3E3H3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:29:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45183 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab3E3H24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:28:56 -0400
Date: Thu, 30 May 2013 09:28:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Ortiz, Lance E" <lance.oritz@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] aerdrv: Move cper_print_aer() call out of interrupt
 context
Message-ID: <20130530072849.GA20793@pd.tnic>
References: <20130529190326.24171.86905.stgit@grignak.americas.hpqcorp.net>
 <30463843.EmBn1xaq3I@vostro.rjw.lan>
 <3908561D78D1C84285E8C5FCA982C28F2DA70112@ORSMSX106.amr.corp.intel.com>
 <A961433CDFF2F640A2866803152E61F95D13A6F2@G9W0715.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A961433CDFF2F640A2866803152E61F95D13A6F2@G9W0715.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 04:55:20AM +0000, Ortiz, Lance E wrote:
> This TODO is a note for future clean-up and is not directly related to
>the bug being fixed with this patch. Which lends to the argument of why
>put the TODO in this patch? Opportunistic. I don’t think we want to
>create a separate patch just for a TODO note.

Sounds to me, this TODO item should be on your TODO list - not in kernel
sources :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
