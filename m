Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbaLJUtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:49:25 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:51763 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaLJUtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:49:23 -0500
MIME-Version: 1.0
In-Reply-To: <5488AF8D.5070702@linux.intel.com>
References: <alpine.DEB.2.11.1412091504490.16275@nanos>
	<CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com>
	<5488A203.7000600@linux.intel.com>
	<CA+55aFwTpZ8U7vUvBE8xkX1_vfktyVDcCwchssMhhP44M8TzUg@mail.gmail.com>
	<5488AF8D.5070702@linux.intel.com>
Date: Wed, 10 Dec 2014 12:49:22 -0800
X-Google-Sender-Auth: CFSQrdvnae1HRWRPZ6D6tyognEI
Message-ID: <CA+55aFwzCuFCzASb4Kj1WC7S9v1wSKN2dHj_ns_1uy2GG6Svqw@mail.gmail.com>
Subject: Re: [GIT pull] x86 mpx support for 3.19
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 12:39 PM, Dave Hansen
<dave.hansen@linux.intel.com> wrote:
>
> I misspoke there.  I meant SMAP (I placed MPX below its config option).

Ok, I agree on SMAP, we might want to have that be configurable too,
especially for smaller systems (I *think* SMAP is big-core only,
right?). I'm not sure how much of a possible performance downside it
has, but it does add instructions to potentially critical areas.

                     Linus
