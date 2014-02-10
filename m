Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaBJMk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:40:27 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34077 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaBJMkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:40:23 -0500
MIME-Version: 1.0
In-Reply-To: <1391957106.25424.12.camel@x220>
References: <1391957106.25424.12.camel@x220>
Date: Mon, 10 Feb 2014 16:40:22 +0400
Message-ID: <CAMo8Bf+RH9qFu2+EC66=49BA_G2abVMLR=t2-aKafOgUJdRAsw@mail.gmail.com>
Subject: Re: [PATCH] xtensa: no need to select USE_GENERIC_SMP_HELPERS
From: Max Filippov <jcmvbkbc@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Chris Zankel <chris@zankel.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 9, 2014 at 6:45 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Commit f615136c06a7 ("xtensa: add SMP support") added "select
> USE_GENERIC_SMP_HELPERS". But the Kconfig symbol USE_GENERIC_SMP_HELPERS
> was already removed in v3.13, so that select is a nop. Drop it.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
>
> USE_GENERIC_SMP_HELPERS was removed in commit 0a06ff068f12 ("kernel:
> remove CONFIG_USE_GENERIC_SMP_HELPER").
>
>  arch/xtensa/Kconfig | 1 -
>  1 file changed, 1 deletion(-)

Thanks, applied to my xtensa tree.

-- Max
