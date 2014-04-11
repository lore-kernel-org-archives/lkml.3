Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaDKUl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:41:59 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37820 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbaDKUl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:41:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140411105604.GR6518@sirena.org.uk>
References: <20140411105604.GR6518@sirena.org.uk>
Date: Fri, 11 Apr 2014 13:41:56 -0700
X-Google-Sender-Auth: rqY3qksaPX4qSEqpr6gFWWjDcdg
Message-ID: <CA+55aFxCubywWSLdhAva9dvj26=o4WkaVnhYjgEKrEuMuaFo+g@mail.gmail.com>
Subject: Re: [GIT PULL] spi fixes for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-spi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 3:56 AM, Mark Brown <broonie@kernel.org> wrote:
>
> Same issue as on the regulator pull request with the entire diffstat for
> the original pull request for this merge window has appeared - like I
> say I will try to fix the scripts as it's annoying and unclear.

Yeah, looking at this, the problem does seem to be that extraneous
merge. I'm not sure why you did that "Merge tag 'spi-v3.15' into
spi-linus" at all, but it basically acts as an indirect back-merge
giving you two different merge bases.

You seem to start your development by doing a merge of that tag that
you sent me. Why? Why not just start *at* the tag you sent me, not at
that extraneous merge of that tag and v3.14.

               Linus
