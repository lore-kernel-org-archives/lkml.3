Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaKLVxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:53:44 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51711 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaKLVxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:53:41 -0500
MIME-Version: 1.0
In-Reply-To: <87ppctm0zs.fsf@rustcorp.com.au>
References: <87ppctm0zs.fsf@rustcorp.com.au>
Date: Wed, 12 Nov 2014 13:53:40 -0800
X-Google-Sender-Auth: a4Od0VQyncehYwIQR05lQn-K4Xk
Message-ID: <CA+55aFwPkmvWiy9+aeg-LpWewfOVQ4if0q_5ROZs9StR96r07A@mail.gmail.com>
Subject: Re: [PULL] params fix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Richard Weinberger <richard@nod.at>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 9:39 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git

Hmm. No proper branch name. I'm assuming it's "tags/fixes-for-linus",
which seems to contain the proper commit id:

> for you to fetch changes up to 3438cf549d2f3ee8e52c82acc8e2a9710ac21a5b:

  ...
  447a55fea65010824295d605109f4bbbf1cd7ac2        refs/tags/fixes-for-linus
  3438cf549d2f3ee8e52c82acc8e2a9710ac21a5b        refs/tags/fixes-for-linus^{}
  ...

but please fix whatever script it is you have that didn't list that tag name..

                    Linus
