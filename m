Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3ELBeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 21:34:17 -0400
Received: from smtp.syd.comcen.com.au ([203.23.236.77]:3355 "EHLO
	smtp.syd.comcen.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3ELBeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 21:34:16 -0400
Message-ID: <518EF11A.7060706@spin.net.au>
Date: Sun, 12 May 2013 11:32:10 +1000
From: Chris Jones <chrisjones@spin.net.au>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3-10-rc1
References: <CA+55aFwfK661zATyUpjkXJo1av51nmMweYdPJE7Le7S2KS3xwg@mail.gmail.com>
In-Reply-To: <CA+55aFwfK661zATyUpjkXJo1av51nmMweYdPJE7Le7S2KS3xwg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-comcen-MailScanner-Information: Please contact the ISP for more information
X-comcen-MailScanner: Found to be clean
X-comcen-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.82, required 4, AWL 0.68, BAYES_00 -2.60, RDNS_NONE 0.10)
X-comcen-MailScanner-From: chrisjones@spin.net.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2013 11:00 AM, Linus Torvalds wrote:
> So this is the biggest -rc1 in the last several years (perhaps ever)
> at least as far as counting commits go, even if not necessarily in
> actual lines (I didn't check the statistics on that).
>
> Which was unexpected, because while linux-next was fairly big, it
> wasn't exceptionally so. I'm sure Stephen Rothwell will talk about the
> statistics of commits that weren't in -next, we'll see if that was the
> reason..
>
> Anyway, despite the large number of commits, hopefully it's all
> boringly straigthforward. Sure.
>
> Now, even normally, there's no way to list all the changes, much less
> so when it's an unusually large -rc1. But I can do my "merge shortlog"
> again, and it's worth mentioning (again) that the name attributed to
> the merge is *not* necessarily the author of any of the code, it's
> literally just the person who emailed me the pull request. So you can
> see this as an approximation of "first-level maintainership" or
> something, although even that is somewhat misleading since some of
> these things are really done by groups and then there's one person who
> end up sending me the end result.
>
> But it's somewhat readable, and gives you a reasonable idea of what is
> going on. A better idea can be gotten by looking at git directly,
> especially since the merge commits often do contain a better
> description of what happened. Not that all submaintainers necessarily
> always send me that, but most of the merges actually do have
> human-readable background information.
>
> It's possible that I missed something. This really was a busier merge
> window than usual. Holler if so,
>
>                     Linus
>
> <snip>

Thanks for the summary of changes. That helps.


Regards

Chris Jones


-- 
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.13 (GNU/Linux)

mQENBFF7bwcBCADREEkM0EcEvY6Zt3Zot5RWk5+a6qMZzj6Qf8tZnG2mjyb/NrOa
ujQhakpkmUj2Cpf04jacEKnjxO5Bk6794QPoSelHAkLFol9XRO6j+94tp+21mrGL
GRHppU8LGGCTrllIJOmKdx2dmqIfYKoRcLs/gA1z0ZrNNz+J3OrcWfDWfVz0eWg6
TeXn4PBAQYr8Ci1fF9/vwxeSQx3PGzJjlzKXsbx/etjICDVVkUAxYkEPbazV1LGx
gwDlhCT5YWQQXdESIbUkQFAbCyglM/HkMNEm23AI/z4PhgjdHBCg8LeQTEUiO+a+
b1ypRMZRpn/je96/PE1ZP5TxaEhaimL+OA+dABEBAAG0JENocmlzIEpvbmVzIDxj
aHJpc2pvbmVzQHNwaW4ubmV0LmF1PokBPgQTAQIAKAUCUXtvBwIbAwUJACdPGQYL
CQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQxifpw+rbaJQQBwf+M+arauGqAtkA
LP3Duk0FdDZ3cIbKST3oQd10eACdkH7fQibvtVadkiCeC7CbozSI50o+Snk8/Azd
5V32LkmzUcUEGrnx3B9oZlWMSKZFz5y1rN0YiplQwc4KLq1cSYOZFpVHUZ/ivcJn
k+p+cuLWQrNUI5kiFV+x6lOKIkKgmMrmuKxbwYskPPtE1DIJ7Qh8H/N9aTJ34KAD
+O4dMwDlA2dYDoQYmyCMcly6W6NdPQmww1XX5qmY+obokScIJE5mYUyiFz0kiN6C
NsosjMsUxbrNEPjAfzyU5Y+LqffYJzgyTjlORRqldZU6IDhsmtyDBoshGQFAEm6W
dRQOrNYx6A==
=FJFi
-----END PGP PUBLIC KEY BLOCK-----

