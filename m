Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbaFYNGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:06:31 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50523 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaFYNG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:06:29 -0400
Date: Wed, 25 Jun 2014 14:04:40 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linux-arch@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v8 1/1] man-pages: seccomp.2: document syscall
Message-ID: <20140625140440.6870eac1@alan.etchedpixels.co.uk>
In-Reply-To: <20140624205615.GW5412@outflux.net>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
	<20140624205615.GW5412@outflux.net>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014 13:56:15 -0700
Kees Cook <keescook@chromium.org> wrote:

> Combines documentation from prctl, in-kernel seccomp_filter.txt and
> dropper.c, along with details specific to the new syscall.

What is the license on the example ? Probably you want to propogate the
minimal form of the text in seccomp/dropper into the document example to
avoid confusion ?

Alan
