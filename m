Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3JDUW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:22:26 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:43497 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3JDUWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:22:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130928175956.8752.50967.stgit@amt.stowe>
References: <20130928175956.8752.50967.stgit@amt.stowe>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 4 Oct 2013 14:22:03 -0600
Message-ID: <CAErSpo5iFVZn4kanEHY=cWzt1ynQYt4XDX+iNP-fn1qm89e+5Q@mail.gmail.com>
Subject: Re: [PATCH] mn10300/PCI: Remove pci_mem_start
To: Myron Stowe <myron.stowe@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 11:59 AM, Myron Stowe <myron.stowe@redhat.com> wrote:
> Remove unused 'pci_mem_start' variable.
>
> CC: David Howells <dhowells@redhat.com>
> CC: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>

Applied to pci/misc with David's ack.  Thanks!

Bjorn

> ---
>
>  arch/mn10300/include/asm/pci.h |    1 -
>  arch/mn10300/kernel/setup.c    |    3 ---
>  2 files changed, 0 insertions(+), 4 deletions(-)
>
> diff --git a/arch/mn10300/include/asm/pci.h b/arch/mn10300/include/asm/pci.h
> index 6f31cc0..1663238 100644
> --- a/arch/mn10300/include/asm/pci.h
> +++ b/arch/mn10300/include/asm/pci.h
> @@ -44,7 +44,6 @@ extern void unit_pci_init(void);
>  #define pcibios_assign_all_busses()    0
>  #endif
>
> -extern unsigned long pci_mem_start;
>  #define PCIBIOS_MIN_IO         0xBE000004
>  #define PCIBIOS_MIN_MEM                0xB8000000
>
> diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
> index ebac9c1..2ad7f32 100644
> --- a/arch/mn10300/kernel/setup.c
> +++ b/arch/mn10300/kernel/setup.c
> @@ -35,9 +35,6 @@
>
>  struct mn10300_cpuinfo boot_cpu_data;
>
> -/* For PCI or other memory-mapped resources */
> -unsigned long pci_mem_start = 0x18000000;
> -
>  static char __initdata cmd_line[COMMAND_LINE_SIZE];
>  char redboot_command_line[COMMAND_LINE_SIZE] =
>         "console=ttyS0,115200 root=/dev/mtdblock3 rw";
>
