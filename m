Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaIZC1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:27:36 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36356 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaIZC1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:27:34 -0400
MIME-Version: 1.0
In-Reply-To: <1410168160-3624-29-git-send-email-lftan@altera.com>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
	<1410168160-3624-29-git-send-email-lftan@altera.com>
Date: Fri, 26 Sep 2014 10:27:32 +0800
X-Google-Sender-Auth: KJ4DKJ6GVXQGf94qOszHdULiEWc
Message-ID: <CAFiDJ5_J0a0OWkX6FV=Gqz6J6BWcyYYOvZyAS9oRqvMaq4Nftw@mail.gmail.com>
Subject: Re: [PATCH v3 28/29] Documentation: Add documentation for Nios2 architecture
From: Ley Foon Tan <lftan@altera.com>
To: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Cc: Ley Foon Tan <lftan@altera.com>, LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>, rdunlap@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 5:22 PM, Ley Foon Tan <lftan@altera.com> wrote:
> Signed-off-by: Ley Foon Tan <lftan@altera.com>
> ---
>  Documentation/nios2/README | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>  create mode 100644 Documentation/nios2/README
>
> diff --git a/Documentation/nios2/README b/Documentation/nios2/README
> new file mode 100644
> index 0000000..054a67d
> --- /dev/null
> +++ b/Documentation/nios2/README
> @@ -0,0 +1,23 @@
> +Linux on the Nios II architecture
> +=================================
> +
> +This is a port of Linux to Nios II (nios2) processor.
> +
> +In order to compile for Nios II, you need a version of GCC with support for the generic
> +system call ABI. Please see this link for more information on how compiling and booting
> +software for the Nios II platform:
> +http://www.rocketboards.org/foswiki/Documentation/NiosIILinuxUserManual
> +
> +For reference, please see the following link:
> +http://www.altera.com/literature/lit-nio2.jsp
> +
> +What is Nios II?
> +================
> +Nios II is a 32-bit embedded-processor architecture designed specifically for the
> +Altera family of FPGAs. In order to support Linux, Nios II needs to be configured
> +with MMU and hardware multiplier enabled.
> +
> +Nios II ABI
> +===========
> +Please refer to chapter "Application Binary Interface" in Nios II Processor Reference
> +Handbook.
> --
> 1.8.2.1
>

Add Randy to CC list.
