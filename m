Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3KLTNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:13:04 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:48567 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab3KLTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:13:00 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1384283245-9419-4-git-send-email-geert@linux-m68k.org>
References: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
	<1384283245-9419-4-git-send-email-geert@linux-m68k.org>
Date: Tue, 12 Nov 2013 11:12:57 -0800
Message-ID: <CAOesGMiPJU9sRWptxqC_GsvBX0jdsbhfGpvG0OKpL98Q1o1YfQ@mail.gmail.com>
Subject: Re: [PATCH 03/12] mtd: pasemi_nand.c: Remove superfluous name cast
From: Olof Johansson <olof@lixom.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 11:07 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> device_driver.name is "const char *"
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: linux-mtd@lists.infradead.org

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
