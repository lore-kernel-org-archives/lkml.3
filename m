Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3KUU1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:27:09 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:52114 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3KUU1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:27:06 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20131121104911.GM2674@sirena.org.uk>
References: <20131120175814.GC27423@saruman.home>
	<20131120203400.GL2674@sirena.org.uk>
	<20131120205143.GA9182@saruman.home>
	<20131121024840.GA22970@saruman.home>
	<20131121104911.GM2674@sirena.org.uk>
Date: Thu, 21 Nov 2013 12:27:06 -0800
Message-ID: <CAOesGMi2wDz2PB7GJbfg3i4bRU+qgT+ubTa+WurQ96biyjaLsw@mail.gmail.com>
Subject: Re: commit c368e5fc2a190923b786f2de3e79430ea3566a25 regresses MMC
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@kernel.org>
Cc: Felipe Balbi <balbi@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 2:49 AM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Nov 20, 2013 at 08:48:41PM -0600, Felipe Balbi wrote:
>
>> actually, I didn't miss you at all. your broonie@linaro.org was in Cc
>> of original email thread. The same email which was used to sign-off on
>> original commit.
>
> It's not what's advertised in MAINTAINERS, you should be sending stuff
> to that address.  My work account is completely separate and for various
> reasons (including the fact that a lot of the mails for upstream sent
> there are duplicates of mails sent here) non-automatic upstream stuff
> has a good chance of getting dropped on the floor and at the very least
> will be dealt with more slowly.

If you have one email address listed in MAINTAINERS, and do all your
actual work with another identity, you might want to look at your
workflow a bit. I suggest either signing off with the MAINTAINERS
email address, or changing the entries of that file. People should
expect to be able to email you on the address you sign off with.


-Olof
