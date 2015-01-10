Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbbAJTmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 14:42:49 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:47995 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbbAJTms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 14:42:48 -0500
MIME-Version: 1.0
In-Reply-To: <20150110104627.GA8281@rhlx01.hs-esslingen.de>
References: <CA+55aFy+7+-8CHpmOjRXh1txpABRK3PC+7yZ+fESVAmveOWDyw@mail.gmail.com>
	<20150110104627.GA8281@rhlx01.hs-esslingen.de>
Date: Sat, 10 Jan 2015 11:42:47 -0800
X-Google-Sender-Auth: GihXKYSEJO5A2D7uSUfQpqjsgNY
Message-ID: <CA+55aFw_QqayT8mYJP-wPjs0FuGo8rBiUv00+CzQrQotgn6bPw@mail.gmail.com>
Subject: Re: Linux 3.19-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andreas Mohr <andi@lisas.de>
Cc: David Lang <david@lang.hm>, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 2:46 AM, Andreas Mohr <andi@lisas.de> wrote:
>
> Yet that is what any VirtualAlloc() call on Windows does
> One thing less left to wonder why 'doze is such a performance pig...

Well, to be fair, you shouldn't use VirtualAlloc() as some 'malloc()'
replacement. It's  more of a backing store allocator for malloc() and
friends than anything else.

                         Linus
