Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbaLKUUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:20:04 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:35150 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaLKUUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:20:01 -0500
MIME-Version: 1.0
In-Reply-To: <54873864.3050606@mvista.com>
References: <54873864.3050606@mvista.com>
Date: Thu, 11 Dec 2014 12:19:59 -0800
X-Google-Sender-Auth: yLUoZRmbPBwUHXJDMoqEyDOqrVg
Message-ID: <CA+55aFwYTY1gzRF26cZi2nMm6vDPfEBiSfZmXEUtWa39YjcSRg@mail.gmail.com>
Subject: Re: [GIT PULL] ipmi driver updates
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Corey Minyard <cminyard@mvista.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Rex <tony.rex@ericsson.com>,
        Magnus Johansson E <magnus.e.johansson@ericsson.com>,
        =?UTF-8?Q?Per_Fogelstr=C3=B6m?= <per.fogelstrom@ericsson.com>,
        Jeremy Kerr <jk@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>,
        Sanjeev <singhsan@codeaurora.org>, Thomas Renninger <trenn@suse.de>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 9:59 AM, Corey Minyard <cminyard@mvista.com> wrote:
>
> git://git.code.sf.net/p/openipmi/linux-ipmi openipmi-linux-ipmi for-linus

Can't do.

Not only is there no "for-linus" branch there, even if there was, I
wouldn't pull it. I really want signed tags when pulling from random
git repositories. So when pulling from places like guthub or
sourceforge, I want that signature to verify the identity of the tree,
when the site itself doesn't do it.

Please fix up..

                     Linus
