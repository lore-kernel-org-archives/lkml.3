Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab3EAVTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 17:19:47 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42947 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab3EAVTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 17:19:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130501190553.GC7800@kernel.dk>
References: <20130430195214.GH9931@google.com>
	<20130501072616.GH7800@kernel.dk>
	<20130501185450.GA4057@moria.home.lan>
	<20130501190553.GC7800@kernel.dk>
Date: Wed, 1 May 2013 14:19:43 -0700
Message-ID: <CAC7rs0s7_EBcvLGtbFKcjOofhZC3U=PXoPqR3C7Doo8dKJTFXQ@mail.gmail.com>
Subject: Re: [GIT PULL] Bcache fixes for 3.10
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <koverstreet@google.com>, akpm@linux-foundation.org,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 12:05 PM, Jens Axboe <axboe@kernel.dk> wrote:
> Nope, in fact your series was on top of the last commit I got from you,
> cef52797. Only non-bcache in between. Just wondering how that 215
> insertions and 118 deletions becames 213/112 for that case.

Oh, that. That was a last minute bugfix, just backed out part of a
change. Sorry :P
