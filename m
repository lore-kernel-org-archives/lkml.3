Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaIFOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 10:16:57 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:65117 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaIFOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 10:16:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: behanw@converseincode.com, catalin.marinas@arm.com, will.deacon@arm.com,
        zhichang.yuan@linaro.org, Mark Charlebois <charlebm@gmail.com>,
        dsaxena@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: LLVMLinux: Provide __aeabi_* symbols which are needed for clang
Date: Sat, 06 Sep 2014 16:16:21 +0200
Message-ID: <2954780.2t9bpyu7ov@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409959394-14936-1-git-send-email-behanw@converseincode.com>
References: <1409959394-14936-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:o1CV6ZiBOXhvINmqPDy0IgS1CHmt8nFt6wnpdfYOm15
 Nmt2AqH4I2yODtt+KaDmO795UXIN+U3/eOPz0pAKIaOzs3JfKf
 is0F5dwRDCj3yOlYQrHyUOe16pgWSMryPjCNCJc++ldeTMR9Zx
 DyAnUFe6n2NP5wcSV75ttZOrGhljlg6zjGcLEp8iUjTF1WJiO0
 MuUnN1hT9m5jvmGgE+vGy/hb5FxpmE7GSL7YjvdIlh7gI4AtkK
 z4H9W2UC3v4QpznHxdP2eA4nSx6L2d5SVttX5LvJaAIud3B7Jo
 3z+NdB+5qYB+LRe3xuEQEHK2EUy4Bb3aJUCePu3WKS7UhQXLnh
 oXZNhzoWvS/+N8tRP09c=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 16:23:14 behanw@converseincode.com wrote:
> --- /dev/null
> +++ b/arch/arm64/lib/eabi.c
> @@ -0,0 +1,32 @@
> +/*
> + *  linux/lib/eabi.c

Please don't put the file names in the files themselves, it's redundant
and in this case actually wrong.

> + *  Copyright (C) 2012  Mark Charlebois
> + */
> +
> +/*
> + * EABI routines

Does EABI specify these function names? I would think that they are
just random libgcc (whatever that is called in clang) functions.

	Arnd
