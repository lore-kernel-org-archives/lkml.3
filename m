Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3KOWJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:09:31 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:33867 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3KOWJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:09:22 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8MBbL-WpcC6_wfZeFW6Buqq0p1PStH5ScF-USHae40H3MXfg@mail.gmail.com>
References: <1383833644-27091-1-git-send-email-kirill.shutemov@linux.intel.com>
	<CA+8MBbL-WpcC6_wfZeFW6Buqq0p1PStH5ScF-USHae40H3MXfg@mail.gmail.com>
Date: Fri, 15 Nov 2013 14:09:21 -0800
Message-ID: <CA+8MBbJR+AbGY41=TMOfJUd2u927ADa8O_-12sFUcNYnN34oMw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Properly separate the bloated ptl from the
 regular case
From: Tony Luck <tony.luck@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 2:01 PM, Tony Luck <tony.luck@gmail.com> wrote:
> My "grep" skills are failing to find the Makefile that decides it wants to build
> kernel/bounds.s so early :-(

... and then seconds later I found it in the top-level "Kbuild" file.

But it looks ugly ... comment says we might need this before asm-offsets.h
(which is the reverse of the ia64 case ... we need asm-offsets.h before we
can make bounds.s).

Help!

-Tony
