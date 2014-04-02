Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbaDBAhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:37:05 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:65213 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbaDBAhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:37:03 -0400
MIME-Version: 1.0
In-Reply-To: <1396396987-15621-1-git-send-email-andi@firstfloor.org>
References: <1396396987-15621-1-git-send-email-andi@firstfloor.org>
Date: Tue, 1 Apr 2014 17:37:01 -0700
X-Google-Sender-Auth: 4S-N7Str-04j1Z2R08L8PE1waSY
Message-ID: <CA+55aFwj9zY9Wc+s4BTXjfq09sf3GPnke_0YNT6dGCRgL3VTMw@mail.gmail.com>
Subject: Re: [PATCH] asmlinkage, x86: Remove leftover extern __visible
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 5:03 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Remove the left over extern __visible Linus objected too.
> They should be useless, as we only need the visible
> on the actual definitions.

Ack. I'm going to assume that I'll get this together with the other
__visibility patches in some LTO branch eventually..

           Linus
