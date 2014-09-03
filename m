Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaICE3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 00:29:40 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:45164 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaICE3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 00:29:39 -0400
MIME-Version: 1.0
In-Reply-To: <1409718353.2715.3.camel@joe-AO725>
References: <CAJhHMCDMuByuTdOwTscZ0tF3WopYrqfYnRD=5sPHXGQZZu09wg@mail.gmail.com>
 <1409718353.2715.3.camel@joe-AO725>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 3 Sep 2014 00:29:07 -0400
Message-ID: <CAJhHMCBuUvSb46Q+kvryv2vu=1Pjq8odSs6u7P1h3HyG21k2AA@mail.gmail.com>
Subject: Re: Bogus error in checkpatch.pl
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Wed, Sep 3, 2014 at 12:25 AM, Joe Perches <joe@perches.com> wrote:
>
> You need to use parentheses around the description like:
>         commit <commitid> ("commit description")
>
> For your case:
>
> Commit 615cc2c9cf95 ("Documentation/memory-barriers.txt: fix important
> typo re memory barriers")
>

Ah, OK. But the error message does not say anything about missing
paranetheses and only stresses on chars in the id:

$ ./scripts/checkpatch.pl
patch_dir/0001-doc-memory-barriers.txt-Correct-example-for-reorderi.patch
ERROR: Please use 12 or more chars for the git commit ID like: 'Commit
615cc2c9cf95 ("Documentation/memory-barriers.txt: fix important typo
re memory barriers")'
#8:
Commit 615cc2c9cf95 "Documentation/memory-barriers.txt: fix important typo re


Is it possible to make it a bit clearer, perhaps?

Thanks!
-- 
Pranith
