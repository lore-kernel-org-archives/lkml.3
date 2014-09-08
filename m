Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaIHTuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:50:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59487 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbaIHTul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:50:41 -0400
Message-ID: <540E0860.2030600@zytor.com>
Date: Mon, 08 Sep 2014 12:49:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>
CC: LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v5 0/5] x86: two-phase syscall tracing and seccomp fastpath
References: <cover.1409954077.git.luto@amacapital.net> <CAGXu5jJpxzbpZfxXoBvDm6W-ogq3d5njRa2ir0text3evJT+QQ@mail.gmail.com>
In-Reply-To: <CAGXu5jJpxzbpZfxXoBvDm6W-ogq3d5njRa2ir0text3evJT+QQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 12:29 PM, Kees Cook wrote:
> 
> As far as doing pulls, Peter, can you take the seccomp change from my
> tree as well? It makes sense to land all of this together.
> 

That is the plan.

	-hpa


