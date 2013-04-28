Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3D1KYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 06:24:39 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:50976 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3D1KYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 06:24:37 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <1367086831-10740-1-git-send-email-geert@linux-m68k.org>
References: <1367086831-10740-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 28 Apr 2013 11:24:35 +0100
X-Google-Sender-Auth: Kfgb-1Ul6dXXrwdYDTFJrHhVTf8
Message-ID: <CAAG0J982gbca3XHHSpTHgqPgeGyJRtG8Lm1cWsT0HsThqdFeMw@mail.gmail.com>
Subject: Re: [PATCH -next] ia64, metag: Do not export min_low_pfn in
 arch-specific code
From: James Hogan <james.hogan@imgtec.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sanjay Lal <sanjayl@kymasys.com>, Ralf Baechle <ralf@linux-mips.org>,
        kvm@vger.kernel.org, linux-mips@linux-mips.org,
        linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 April 2013 19:20, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> As of commit 787dcbe6984b3638e94f60d807dcb51bb8a07211 ("MIPS: Export
> symbols used by KVM/MIPS module"), min_low_pfn is already exported by
> the generic mm/bootmem.c, causing:
>
> WARNING: vmlinux: 'min_low_pfn' exported twice. Previous export was in vmlinux
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

This has been pointed out several times and needs fixing in the mips
tree where the warning was introduced.

Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James
