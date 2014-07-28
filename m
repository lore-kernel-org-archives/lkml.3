Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaG1Qpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:45:49 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:64267 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaG1Qpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:45:46 -0400
MIME-Version: 1.0
In-Reply-To: <y0m7g2xk6ss.fsf@fche.csb>
References: <53D064C7.5050807@daenzer.net>
	<CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
	<53D1B1EF.7030603@daenzer.net>
	<20140725035527.GA30108@pg-vmw-gw1>
	<20140725140237.GB32669@home.goodmis.org>
	<CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
	<CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
	<CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
	<20140726193557.GA21842@x4>
	<CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
	<20140726201914.GB21842@x4>
	<CA+55aFyCh8B4kuc66_+wr8eM+kP7-hJ9utdtpLih661Xf8YGgQ@mail.gmail.com>
	<y0m7g2xk6ss.fsf@fche.csb>
Date: Mon, 28 Jul 2014 09:45:45 -0700
X-Google-Sender-Auth: 9ZzqmKEu8i8dPmMP4d9YrdyMEmY
Message-ID: <CA+55aFwz+stjg5L7aKuPjLym3u4FPS_ugSZiCcJwOYCGMSFGVQ@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 5:26 AM, Frank Ch. Eigler <fche@redhat.com> wrote:
>
> Please note that the data produced by "-g -fvar-tracking" is consumed
> by tools like systemtap, perf, crash, and makes a significant
> difference to the observability of debug AND non-debug kernels.

Yeah, and compared to having a buggy kernel, I care exactly this much: "".

Besides, "significant difference" is very debatable indeed. It may be
noticeable, it's likely not actually significant.

              Linus
