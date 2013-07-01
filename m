Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3GALIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 07:08:00 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:61034 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3GALH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130701075856.6e8daa98.mchehab@redhat.com>
References: <20130701075856.6e8daa98.mchehab@redhat.com>
Date: Mon, 1 Jul 2013 16:37:58 +0530
Message-ID: <CAHFNz9J_FJP4YcCd3-_3x6d5iNDoqpYMMtX1Xd+OFJX4H7so0A@mail.gmail.com>
Subject: Re: [GIT PULL for v3.11] media patches for v3.11
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

On Mon, Jul 1, 2013 at 4:28 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Linus,
>
> Please pull from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
>
> For the media patches for Kernel v3.11.
>

>
> Zoran Turalija (2):
>       [media] stb0899: allow minimum symbol rate of 1000000
>       [media] stb0899: allow minimum symbol rate of 2000000


Somehow, I missed these patches; These are incorrect. Please revert
these changes.
Simply changing the advertized minima values don't change the search algorithm
behaviour, it simply leads to broken behaviour.

NACK for these changes.


Regards,

Manu
