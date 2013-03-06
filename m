Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3CFUkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:40:55 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49016 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab3CFUkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:40:53 -0500
MIME-Version: 1.0
In-Reply-To: <0000013d40918dba-4b124e7a-e591-4e75-b568-e1ff9a8d9f03-000000@email.amazonses.com>
References: <alpine.LFD.2.02.1303041234550.3981@tux.localdomain>
	<CA+55aFxV=xs9a8H1YbFSjNzMeebixFaA4hShdHwfRKndFU8FUA@mail.gmail.com>
	<0000013d40918dba-4b124e7a-e591-4e75-b568-e1ff9a8d9f03-000000@email.amazonses.com>
Date: Wed, 6 Mar 2013 22:40:52 +0200
X-Google-Sender-Auth: vgz4p69Lgo0_3e1lOtG87GTcN4U
Message-ID: <CAOJsxLFVKXPTuDgjB5nsjWqMe2rib5OdeE1sqBT_pgOqzGb5_Q@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v3.9-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Wed, Mar 6, 2013 at 6:38 PM, Christoph Lameter <cl@linux.com> wrote:
> Well this stuff was already ready for 3.8 and missed that merge period as
> well. There are a couple of bug fixes included as well. It is the basis
> for more common code between allocators. Most of it is renaming things so
> that fields have a common name which enables more code sharing.

It was me who missed the merge window - sorry about that. But is there
really any real need to push this through at such late stage? People
will work on "slab/next" branch anyway so what's the rush?

We had quite a lot of changes due to slab memcg and I'd rather keep
things calm for this release cycle. It usually takes a few cycles for
people to start noticing problems and it doesn't really help if
there's code churn going on all the time.

                        Pekka
