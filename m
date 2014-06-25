Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbaFYRIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:08:06 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:61601 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbaFYRIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:08:04 -0400
MIME-Version: 1.0
In-Reply-To: <53A9FE04.2000306@hp.com>
References: <20140403191558.GA8745@thunk.org>
	<alpine.LFD.2.11.1406242251230.23403@eddie.linux-mips.org>
	<53A9FE04.2000306@hp.com>
Date: Wed, 25 Jun 2014 10:08:02 -0700
X-Google-Sender-Auth: xJZJX9uhRj7K2e0e3G4s7yhuWfo
Message-ID: <CA+55aFzbC9QgO46m2H47NbUMWssDm-t4YQ8bJggGrZj2h-_9EQ@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 changes for 3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
        T Makphaibulchoke <tmac@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted,
 going through pending issues, and wondering if I'm expected to pick
this up directly? The original came through your tree (commit
1f3e55fe02d1: "fs/mbcache.c: doucple the locking of local from global
data") and is in 3.15 too, so the patch should be marked for stable as
well.

It's hopefully limited to just very bad gcc versions for odd
architectures, so it's not exactly high-impact, but still..

      Linus

On Tue, Jun 24, 2014 at 3:39 PM, Thavatchai Makphaibulchoke
<thavatchai.makpahibulchoke@hp.com> wrote:
>
> I've submitted the fix, using ilog2, and could be found at,
>
> https://lkml.org/lkml/2014/5/30/462
