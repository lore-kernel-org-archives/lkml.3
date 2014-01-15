Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaAOIFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:05:50 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:34252 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaAOIFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:05:48 -0500
MIME-Version: 1.0
In-Reply-To: <1389762075.6933.76.camel@pasglop>
References: <1389762075.6933.76.camel@pasglop>
Date: Wed, 15 Jan 2014 15:05:46 +0700
X-Google-Sender-Auth: Sf4VPeD42MAQXUXV3Hwk5SFnY-w
Message-ID: <CA+55aFyfY5kEezwx8-jhgdgOX+EG__v3QRZmGnGstDpUP-UVWQ@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 12:01 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> My original intend was to put it in powerpc-next and then shoot it to
> stable, but it got a tad annoying (due to churn it needs to be applied
> at least on rc4 or later while my next is at rc1 and clean that way), so
> I put it in the merge branch.

Quite frankly, I'll prefer to not merge it now, and then 3.13 will get
it from stable, when it does things like this.

Partly because it fixes a power-only bug, but potentially changes
non-power behavior. If it was all in arch/powerpc, I wouldn't mind.

               Linus
