Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab3JHTei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:34:38 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:61647 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab3JHTeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx5i=vPeqx9S2WMZdqVC+g-MTczQxPa0mi84Vbs6_YF0g@mail.gmail.com>
References: <20131005234430.GA22485@localhost>
	<CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
	<20131008075151.GA15689@localhost>
	<CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
	<20131008185154.GA8258@redhat.com>
	<20131008190523.GW30970@tucnak.zalov.cz>
	<CA+55aFx5i=vPeqx9S2WMZdqVC+g-MTczQxPa0mi84Vbs6_YF0g@mail.gmail.com>
Date: Tue, 8 Oct 2013 12:34:36 -0700
X-Google-Sender-Auth: 1IA8M3MpvF-ZlU9Fcz27C7D9pKg
Message-ID: <CA+55aFyjcZ0U3c+KjjSNGOhM4xthYA=q60314gG91NcDaw-mmQ@mail.gmail.com>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 12:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll try to see if I can reproduce this on my hardware

Yeah, doesn't reproduce here..

            Linus
