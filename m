Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073Ab3DIMhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:37:23 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:39409 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763878Ab3DIMhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:37:19 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUX-RMW=pHzhOumB2_R99BRAf2qGC4n5bzyLqU6pOCMDFw@mail.gmail.com>
References: <CA+icZUX-RMW=pHzhOumB2_R99BRAf2qGC4n5bzyLqU6pOCMDFw@mail.gmail.com>
Date: Tue, 9 Apr 2013 14:37:18 +0200
Message-ID: <CA+icZUU2dHLz_iWCiJkgnU8HpkWeWbGL0niAoBzoE55CLuvRiQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 12:56 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> Hi,
>
> I still did not get the original posting...
>
> This version hangs... I started in rescue-mode and see that udev,
> premount and init scripts are run.

... udevd ....
/scripts/init-premount ... done
/scripts/pre-premount ... done
/scripts/local-bottom ... done
/scripts/init-bottom ... <--- hanging here!

- Sedat -

> Currently, I have no glue why when what...
> Lemme see if I get k(g)bd started.
>
> Unfortunately, there was a "quiet" boot-param for grub2 here but it's gone.
> With "text" I don't see more.
>
> Maybe, someone has a hint.
>
> Regards,
> - Sedat -
>
>
>
> [1] http://marc.info/?l=linux-next&m=136549987718448&w=2
