Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbaFKQl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:41:58 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:62371 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaFKQl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:41:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140611163628.GA12685@ravnborg.org>
References: <5398749B.4090209@zytor.com>
	<cover.1402503408.git.luto@amacapital.net>
	<20140611163628.GA12685@ravnborg.org>
Date: Wed, 11 Jun 2014 12:41:56 -0400
X-Google-Sender-Auth: dnef61-tEgiRhMkHFAnIWl8iWy4
Message-ID: <CA+5PVA5hScqZ3=86aUqot_2ojHhBNa2PuUTyUZfcCH4nYxP2bg@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86,vdso,kbuild: Fix vdso_install
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:36 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, Jun 11, 2014 at 09:20:05AM -0700, Andy Lutomirski wrote:
>> This changes kbuild slightly because I didn't want to fight with using
>> static pattern rules and extra obfuscated fake targets just to write a
>> loop.
>
> What are you trying to fix with this?
>
> On my box (32 bit Intel) "make MODLIB=~/mod vdso_install"
> works as expected.
> Two *.so files are installed as a copy of the so.dbg files.

With what tree?  With Linus' latest, I reported an error because
commit 6f121e548f83674ab4920a4e60afb58d4f61b829 breaks the
vdso_install target.

josh
