Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab3EBGLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:11:14 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39345
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834Ab3EBGLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:11:10 -0400
Date: Thu, 2 May 2013 08:10:52 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Kent Overstreet <koverstreet@google.com>, akpm@linux-foundation.org,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Bcache fixes for 3.10
Message-ID: <20130502061052.GT7800@kernel.dk>
References: <20130430195214.GH9931@google.com>
 <20130501072616.GH7800@kernel.dk>
 <20130501185450.GA4057@moria.home.lan>
 <20130501190553.GC7800@kernel.dk>
 <CAC7rs0s7_EBcvLGtbFKcjOofhZC3U=PXoPqR3C7Doo8dKJTFXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC7rs0s7_EBcvLGtbFKcjOofhZC3U=PXoPqR3C7Doo8dKJTFXQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01 2013, Kent Overstreet wrote:
> On Wed, May 1, 2013 at 12:05 PM, Jens Axboe <axboe@kernel.dk> wrote:
> > Nope, in fact your series was on top of the last commit I got from you,
> > cef52797. Only non-bcache in between. Just wondering how that 215
> > insertions and 118 deletions becames 213/112 for that case.
> 
> Oh, that. That was a last minute bugfix, just backed out part of a
> change. Sorry :P

Aha! Busted.

-- 
Jens Axboe

