Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaHEUAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:00:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbaHEUA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:00:29 -0400
Date: Tue, 5 Aug 2014 21:58:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 8/8] x86: add comments about various syscall
	instructions, no code changes
Message-ID: <20140805195821.GA30908@redhat.com>
References: <1407250354-29525-1-git-send-email-dvlasenk@redhat.com> <1407250354-29525-9-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407250354-29525-9-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Denys Vlasenko wrote:
>
> This patch adds comments which explain in detail
> what registers are modified by each of these instructions.
> The comments are placed immediately before corresponding
> entry and exit points.

This is great ;) Thanks Denys!

Oleg.

