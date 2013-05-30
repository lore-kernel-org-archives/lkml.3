Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab3E3SNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:13:10 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:51801 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3E3SM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:12:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130530142512.3404.74494.stgit@grignak.americas.hpqcorp.net>
References: <20130530142512.3404.74494.stgit@grignak.americas.hpqcorp.net>
Date: Thu, 30 May 2013 11:12:57 -0700
Message-ID: <CA+8MBbK8FNDtKrTAsTKKNUQqkNQ_R0TGTNC3KSeDW4ASeUZ7Xw@mail.gmail.com>
Subject: Re: [PATCH v4] aerdrv: Move cper_print_aer() call out of interrupt context
From: Tony Luck <tony.luck@gmail.com>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, lance_ortiz@hotmail.com,
        Liu Jiang <jiang.liu@huawei.com>, Borislav Petkov <bp@alien8.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-acpi <linux-acpi@vger.kernel.org>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok - grabbed this version. Will see if I can tempt Linus with a "please pull"
tomorrow (when the commit is suitably aged).

By the way ... this meta-commit description:

> v2 - Re-worded header text.  Removed prefix arg from cper_print_aer().
>      Added TODO message in cper_print_aer().
> v3 - Changed type of u8* to struct aer_capability_regs* in the code
>      to avoid too much casting based on comment from Bjorn Helgaas.
> v4 - Removed TODO message.  Does not have to do with what this patch
>      is trying to fix.

belongs *after* the "---" past the sign-off & Acks ... then "git am" will
drop it from the commit message automatically

-Tony
