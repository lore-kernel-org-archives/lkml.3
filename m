Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaIXKSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:18:55 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:33195 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbaIXKSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:18:52 -0400
MIME-Version: 1.0
In-Reply-To: <13000968.l0laEvMsix@wuerfel>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
	<1410168160-3624-2-git-send-email-lftan@altera.com>
	<CAFiDJ5-b_P7aWFXYP4GcgTUb3t_j6dZCsjeGZwVUs+7qo0v-GA@mail.gmail.com>
	<13000968.l0laEvMsix@wuerfel>
Date: Wed, 24 Sep 2014 18:18:50 +0800
X-Google-Sender-Auth: PcXxK_JsHIw9CAje_2ntyTt2qJY
Message-ID: <CAFiDJ582-Bb2=s+AGsAeTHJMwBkUCUEoEbP770MJgTDkvev0yg@mail.gmail.com>
Subject: Re: [PATCH v3 01/29] asm-generic: add generic futex for !CONFIG_SMP
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 6:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 23 September 2014 18:20:08 LF.Tan wrote:
>> Hi Arnd
>>
>> Are you okay with this generic futex in asm-generic?
>>
>
> Yes, this looks good. Remind me again who need this, would it make
> sense to merge this through an architecture-specific tree for
> whichever architecture can benefit from it?
What is the common practice for this?
Do you mean merge with nios2 or other arch, eg m68k?

Ley Foon
