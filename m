Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab3CQEol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 00:44:41 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:41012 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3CQEok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 00:44:40 -0400
MIME-Version: 1.0
In-Reply-To: <1363447412-23804-1-git-send-email-tom.leiming@gmail.com>
References: <1363447412-23804-1-git-send-email-tom.leiming@gmail.com>
Date: Sat, 16 Mar 2013 21:44:39 -0700
Message-ID: <CANN689HbCEBUTDr9jLP9XwZiZdsDOAeWKZzT7y8FrmBD3Aa=fA@mail.gmail.com>
Subject: Re: [PATCH] mm/fremap.c: fix another oops on error path
From: Michel Lespinasse <walken@google.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Tommi Rantala <tt.rantala@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 8:23 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> Since find_vma() may return NULL, so don't dereference the
> returned 'vma' until it is valid.

Agree this was an issue. This is fixed with commit a2362d24764a.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
