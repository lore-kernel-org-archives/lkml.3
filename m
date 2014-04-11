Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaDKUaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:30:12 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:45591 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaDKUaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:30:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140411103807.GQ6518@sirena.org.uk>
References: <20140411103807.GQ6518@sirena.org.uk>
Date: Fri, 11 Apr 2014 13:30:08 -0700
X-Google-Sender-Auth: OoMbV6ZEp5pwdKyrIvsMpmsRCN0
Message-ID: <CA+55aFznxvzfqa7OM0VoQ337kVYQ0hSjkqC26sxv7mxBuX9J-Q@mail.gmail.com>
Subject: Re: [GIT PULL] regulator fixes for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 3:38 AM, Mark Brown <broonie@kernel.org> wrote:
>
> Due to the way my scripts incorporate the things I already sent since
> your last tag the diffstat has picked up all the changes already sent
> (or I could've generated against my previous pull when it'd show all the
> changes from the final -rc to release).  I will look into fixing that,
> please let me know if it's an immediate problem.

Not an immediate problem, but have you tested just adding a simple
"git fetch" from my repo to your scripts?

Note the "fetch". Not "pull". No merging going on, just updating your
remote branch information with what is in my tree. Then you can just
tell git to generate the report based on that information - never
actually needing to update your own branches at all, or touching your
own development state.

              Linus
