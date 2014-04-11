Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaDKUdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:33:01 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:63980 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaDKUdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:33:00 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFznxvzfqa7OM0VoQ337kVYQ0hSjkqC26sxv7mxBuX9J-Q@mail.gmail.com>
References: <20140411103807.GQ6518@sirena.org.uk>
	<CA+55aFznxvzfqa7OM0VoQ337kVYQ0hSjkqC26sxv7mxBuX9J-Q@mail.gmail.com>
Date: Fri, 11 Apr 2014 13:32:59 -0700
X-Google-Sender-Auth: G_yV-nkpGGs0OdqzhSjJFaoKAu0
Message-ID: <CA+55aFxGbTdk-0mRtrYCRLJ1X6hbbrmOvKpgupA+4X1Cpoj=OQ@mail.gmail.com>
Subject: Re: [GIT PULL] regulator fixes for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 1:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Not an immediate problem, but have you tested just adding a simple
> "git fetch" from my repo to your scripts?

Oh, actually, the problem may just be that back-merge you have. When
those cause multiple merge bases, "git diff" can no longer reliably
generate a diff, since there is no clear base for it. And then "git
fetch" to update my current state won't likely help, since the problem
isn't that you don't see my previous pull, the problem is that the
base isn't unique any more.

              Linus
