Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbbAQLPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 06:15:52 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:44653 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbAQLPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 06:15:50 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1421453410.git.luto@amacapital.net>
References: <cover.1421453410.git.luto@amacapital.net>
Date: Sun, 18 Jan 2015 00:15:49 +1300
X-Google-Sender-Auth: bqijcbmaK96AI_vL4AHz16HMrJo
Message-ID: <CA+55aFzjTHkkgO4V95xio4jvt03hPY80f9UZRv5PS6p7GX8xKA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] x86_64,entry: Rearrange the syscall exit optimizations
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 1:19 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Linus, I suspect you'll either like or hate this series.  Or maybe
> you'll think it's crazy but you'll like it anyway.  I'm curious
> which of those is the case. :)

I have no hugely strong reaction to the patches, but it seems to be a
good simplification of our model, in addition to allowing sysret for
more cases. So Ack, as far as I'm concerned.

           Linus
