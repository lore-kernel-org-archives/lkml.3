Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaJNUo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:44:29 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:60494 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbaJNUo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:44:26 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:2c58:1c44:2f96:71f0]
In-Reply-To: <1413262019-3759-1-git-send-email-chaowang@redhat.com>
References: <1413262019-3759-1-git-send-email-chaowang@redhat.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 14 Oct 2014 16:44:05 -0400
Message-ID: <CAOFdcFPLGgopN_yc0pXmsecRhH8MqE-BXPS_fX3bbgj+MDWNgQ@mail.gmail.com>
Subject: Re: [PATCH] arch/x86/purgatory/Makefile: supress kexec-purgatory.c is
 up to date message
To: WANG Chao <chaowang@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>, Baoquan He <bhe@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 12:46 AM, WANG Chao <chaowang@redhat.com> wrote:
> Supress this unnecessary message during kernel re-build
> (CONFIG_KEXEC_FILE=y):
>
> make[1]: `arch/x86/purgatory/kexec-purgatory.c' is up to date.
>
> Signed-off-by: WANG Chao <chaowang@redhat.com>

Acked-by: Peter Foley <pefoley2@pefoley.com>
