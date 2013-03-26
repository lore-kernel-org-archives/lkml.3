Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238Ab3CZNmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:42:47 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43154 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933069Ab3CZNmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:42:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, lenb@kernel.org,
        robert.moore@intel.com, lv.zheng@intel.com, ming.m.lin@intel.com,
        mpm@selenic.com, herbert@gondor.hengli.com.au, rob@landley.net,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [RESEND PATCH 1/6] acpi: Remove the leading space of "unlock" label in acpi_memory_device_notify().
Date: Tue, 26 Mar 2013 14:50:08 +0100
Message-ID: <1616020.P78CkUi8YT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CACQ1gAia2YsbzV+zT8gTiYvB7JVft3aL1iwC0DBuyCoZ+8wAuQ@mail.gmail.com>
References: <1362558611-32255-1-git-send-email-tangchen@cn.fujitsu.com> <1843378.VZBEQ0WNNo@vostro.rjw.lan> <CACQ1gAia2YsbzV+zT8gTiYvB7JVft3aL1iwC0DBuyCoZ+8wAuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 26, 2013 02:23:49 PM Richard Genoud wrote:
> 2013/3/26 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Wednesday, March 06, 2013 04:30:06 PM Tang Chen wrote:
> >> There is a leading space in front of "unlock" label in acpi_memory_device_notify(). Remove it.
> >>
> >> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> >> ---
> >>  drivers/acpi/acpi_memhotplug.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> >> index da1f82b..8a10c23 100644
> >> --- a/drivers/acpi/acpi_memhotplug.c
> >> +++ b/drivers/acpi/acpi_memhotplug.c
> >> @@ -369,7 +369,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
> >>                       kfree(ej_event);
> >>               }
> >>
> >> - unlock:
> >> +unlock:
> >>               acpi_scan_lock_release();
> >>               if (ACPI_SUCCESS(status))
> >>                       return;
> >
> > The leading space is actually in agreement with the kernel coding style
> > (and there's a reason why it's there).
> 
> Well, I'm curious. What's the reason ?
> I didn't see anything in Documentation/CodingStyle about that.

Some tools had problems with labels starting right at the start of the line.
patch or diff or something similar IIRC.  That's not the case any more, but
there's a leading space before many labels in the kernel and that is part of
the coding style, actually, even if it is not documented.

Certainly, it's not something to fix.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
