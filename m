Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab3CDUJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:09:38 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:42414 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab3CDUJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:09:36 -0500
MIME-Version: 1.0
Date: Mon, 4 Mar 2013 21:09:35 +0100
X-Google-Sender-Auth: OnDLbJmJc-sGTrmh1Hya75xJS4o
Message-ID: <CAMuHMdXtSyoxZ6fyPivGTB4Om97H+q6Vb9LaY3AF58pezA+WDQ@mail.gmail.com>
Subject: =?UTF-8?B?bW0va3NtLmM6NDkyOiBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpbw==?=
	=?UTF-8?B?biDigJhwZm5fdG9fbmlk4oCZ?=
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Petr Holasek <pholasek@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On one of my m68k configs, v3.9-rc1 gives me:

mm/ksm.c: In function ‘get_kpfn_nid’:
mm/ksm.c:492: error: implicit declaration of function ‘pfn_to_nid’

It turns out <linux/mmzone.h> lacks a definition for pfn_to_nid() if
CONFIG_DISCONTIGMEM=y.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
