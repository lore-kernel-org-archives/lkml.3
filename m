Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbaGPKJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:09:21 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:51674 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139AbaGPKJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:09:15 -0400
Date: Wed, 16 Jul 2014 03:07:37 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: David Herrmann <dh.herrmann@gmail.com>
cc: linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Greg Kroah-Hartman <greg@kroah.com>, john.stultz@linaro.org,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Hugh Dickins <hughd@google.com>,
        Tony Battersby <tonyb@cybernetics.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 4/7] selftests: add memfd_create() + sealing tests
In-Reply-To: <1402655819-14325-5-git-send-email-dh.herrmann@gmail.com>
Message-ID: <alpine.LSU.2.11.1407160307160.1775@eggly.anvils>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com> <1402655819-14325-5-git-send-email-dh.herrmann@gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, David Herrmann wrote:

> Some basic tests to verify sealing on memfds works as expected and
> guarantees the advertised semantics.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

Thanks for whatever the fix was, I didn't hit any problem running
this version repeatedly, on 64-bit and on 32-bit.

Hugh
