Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbaIDS5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:57:24 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:53429 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbaIDS5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:57:23 -0400
MIME-Version: 1.0
In-Reply-To: <1409855739-8985-5-git-send-email-toshi.kani@hp.com>
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com> <1409855739-8985-5-git-send-email-toshi.kani@hp.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 4 Sep 2014 11:57:01 -0700
Message-ID: <CALCETrXjpoVmCi07zo0dKH9LrF+nz9F3GshNiQvmiueFFH=TUQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86, mm: Add set_memory_wt() for WT
To: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, akpm@linuxfoundation.org,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 11:35 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> This patch adds set_memory_wt(), set_memory_array_wt(), and
> set_pages_array_wt() for setting range(s) of memory to WT.
>

Possibly dumb question: I thought that set_memory_xyz was only for
RAM.  Is that incorrect?

--Andy
