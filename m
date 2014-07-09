Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbaGIWdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:33:21 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:61544 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaGIWdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:33:20 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:8cce:4220:32bc:b297]
In-Reply-To: <1404324218-4743-3-git-send-email-lauraa@codeaurora.org>
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org>
	<1404324218-4743-3-git-send-email-lauraa@codeaurora.org>
Date: Wed, 9 Jul 2014 15:33:19 -0700
Message-ID: <CAOesGMiKBNDmJhiY-yK0uZmG-MnK82=ffNGxqasLKozqgpQQpw@mail.gmail.com>
Subject: Re: [PATCHv4 2/5] lib/genalloc.c: Add genpool range check function
From: Olof Johansson <olof@lixom.net>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 11:03 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
>
> After allocating an address from a particular genpool,
> there is no good way to verify if that address actually
> belongs to a genpool. Introduce addr_in_gen_pool which
> will return if an address plus size falls completely
> within the genpool range.
>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Reviewed-by: Olof Johansson <olof@lixom.net>

What's the merge path for this code? Part of the arm64 code that needs
it, I presume?


-Olof
