Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3EBIZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:25:40 -0400
Received: from mail.nanl.de ([217.115.11.12]:40096 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab3EBIZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:25:37 -0400
MIME-Version: 1.0
In-Reply-To: <26714880.190151367480353110.JavaMail.weblogic@epv6ml12>
References: <26714880.190151367480353110.JavaMail.weblogic@epv6ml12>
From: Jonas Gorski <jogo@openwrt.org>
Date: Thu, 2 May 2013 10:25:05 +0200
Message-ID: <CAOiHx=kmrQuNd1dbdce4N1wbuLKhCqpSnruC0bMDxsEhY84izA@mail.gmail.com>
Subject: Re: [PATCH] MIPS: remove USB_EHCI_BIG_ENDIAN_{DESC,MMIO} depends on
 architecture symbol
To: eunb.song@samsung.com
Cc: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        florian@openwrt.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 9:39 AM, EUNBONG SONG <eunb.song@samsung.com> wrote:
>
> This patch removes the architecture specific symbols which prevent these
> configuration symbols from being selected by platforms/architectures requiring it.
> I reference commit 9296d94d83649e1c2f25c87dc4ead9c2ab073305.

These are selects and don't prevent anyone else from also selecting
them. If you look at your referenced commit, you see it removed the
/depends/, not the selects. It actually added selects to several
platforms. Platforms are supposed to select them if they need them.


Jonas
