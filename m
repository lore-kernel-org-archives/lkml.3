Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3EPN31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:29:27 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38595 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab3EPN3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:29:21 -0400
MIME-Version: 1.0
In-Reply-To: <90a2283bb84b6ce77c9966d76dbceb5c7edffd18.1368702323.git.mst@redhat.com>
References: <cover.1368702323.git.mst@redhat.com> <90a2283bb84b6ce77c9966d76dbceb5c7edffd18.1368702323.git.mst@redhat.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 16 May 2013 14:29:01 +0100
X-Google-Sender-Auth: cGPSJIWv7wDD-Ng2pUSTxx5yfNs
Message-ID: <CAHkRjk5bHV3WDSnfQLr1MPTXGXXKP+XKRbqL2fn_bPmXt_7=cw@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] arm64: uaccess s/might_sleep/might_fault/
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        microblaze-uclinux@itee.uq.edu.au, linux-am33-list@redhat.com,
        linuxppc-dev@lists.ozlabs.org,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2013 12:10, Michael S. Tsirkin <mst@redhat.com> wrote:
> The only reason uaccess routines might sleep
> is if they fault. Make this explicit.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/arm64/include/asm/uaccess.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

For arm64:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
