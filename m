Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3CUBnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 21:43:11 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60325 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3CUBnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:43:09 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6tXes_ecPsnEnc+MB7K0Zi8wWV6T5=AUyAuDUBEQ-4rSA@mail.gmail.com>
References: <CAAVeFuLjqFoOyqoWWT9fKjs6AB5DU9nT5p+nJ5uhaaUeh4_MXg@mail.gmail.com>
 <20130321104747.b34175b397b5b16d61040fae@canb.auug.org.au> <CACxGe6tXes_ecPsnEnc+MB7K0Zi8wWV6T5=AUyAuDUBEQ-4rSA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 21 Mar 2013 10:42:48 +0900
Message-ID: <CAAVeFu+PxpM9=kbB_HAbHf=6qxNpkbCQxkeFoKEx+swAWpQ_6g@mail.gmail.com>
Subject: Re: New tree for linux-next
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 9:09 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>> - My branch is based on the latest stable, similarly to what I have
>>> seen elsewhere. One of the patches triggers a merge conflict on
>>> today's linux-next due to a whitespace change. Is there something I
>>> can do to fix this?
>>
>> Do not worry about merge conflicts, that is my and Linus' job.
>
> Latest stable? As in based on one of the linux-stable point releases
> (That Greg does) or based on Linus' tree? It must be based on Linus'
> tree to be mergable into mainline.

That's based on Linus' latest rc. "stable" was ambiguous here, sorry.

Alex.
