Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaGUKYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:24:10 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:54618 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbaGUKYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:24:08 -0400
MIME-Version: 1.0
In-Reply-To: <5003438.ZMUcOxtMrE@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<5659104.6O7AZx76W6@wuerfel>
	<CAFiDJ5_hjBQ4tOpsUdgqgwRrJ1TgFSa9pEqc2m+srMj5Fkir=w@mail.gmail.com>
	<5003438.ZMUcOxtMrE@wuerfel>
Date: Mon, 21 Jul 2014 18:24:07 +0800
X-Google-Sender-Auth: DUG5KMM4pKfW6ScTFUp798wwK70
Message-ID: <CAFiDJ5_HeUDDO4mCyGEd=vMMAs5MYAXZ-XuTxwLEvwBspf98XA@mail.gmail.com>
Subject: Re: [PATCH v2 21/29] nios2: Futex operations
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 4:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:

>>
>> Okay, I will copy m68k implementation to asm-generic/futex.h.
>> Do you prefer this as separate patch submission or this can be part of
>> nios2 patchset?
>
> I think it's better for everybody if you include it in your nios2
> patchset, once I've seen the patch and provided an Ack. You can send
> it separately for review at first.
Okay. Will add to my next revision of nios2 patchset.

Thanks.

Regards
Ley Foon
