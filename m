Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab3CDWdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:33:05 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:53326 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab3CDWdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:33:04 -0500
MIME-Version: 1.0
In-Reply-To: <51352116.5030702@infradead.org>
References: <51352116.5030702@infradead.org>
Date: Mon, 4 Mar 2013 14:33:02 -0800
X-Google-Sender-Auth: 9v5CYFW_K8-PDvwo13FpHbn4zHw
Message-ID: <CAOS58YN5z8BHcmuN2tROAvuMWaDOVyNGQFJTw+t5SdynsV+v3Q@mail.gmail.com>
Subject: Re: [PATCH] idr: fix new kernel-doc warnings
From: Tejun Heo <tj@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 2:32 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix new kernel-doc warnings in idr:
>
> Warning(include/linux/idr.h:113): No description found for parameter 'idr'
> Warning(include/linux/idr.h:113): Excess function parameter 'idp' description in 'idr_find'
> Warning(lib/idr.c:232): Excess function parameter 'id' description in 'sub_alloc'
> Warning(lib/idr.c:232): Excess function parameter 'id' description in 'sub_alloc'
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc:     Tejun Heo <tj@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
