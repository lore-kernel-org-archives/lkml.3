Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaDAX3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:29:33 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:37693 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaDAX3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:29:30 -0400
Message-ID: <533B4BAE.5070905@ahsoftware.de>
Date: Wed, 02 Apr 2014 01:28:46 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>, Kees Cook <keescook@chromium.org>
CC: Laura Abbott <lauraa@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] arm: don't allow CONFIG_DEBUG_SET_MODULE_RONX if CONFIG_JUMP_LABEL
 is enabled
References: <1396346657-7166-1-git-send-email-holler@ahsoftware.de> <533AFF77.5030106@codeaurora.org> <CAGXu5jKMF9n9svQBhyQFvCoUe86QhLycDTt-fWyiRfySbn=Fug@mail.gmail.com> <CAH+eYFDkYczZXYF3be6tTRg7kkGhK2zyukDTo+N8mwEKcG89LA@mail.gmail.com>
In-Reply-To: <CAH+eYFDkYczZXYF3be6tTRg7kkGhK2zyukDTo+N8mwEKcG89LA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.04.2014 01:08, schrieb Rabin Vincent:

> +void set_kernel_text_rw(struct mm_struct *mm)

(...)

> +void set_kernel_text_ro(struct mm_struct *mm)

(...)


Hmm, maybe such is doable for jump labels too. But I definitely can't 
discuss on that topic further through missing knowledge. ;)

Regards,

Alexander Holler
