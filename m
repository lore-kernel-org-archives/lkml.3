Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3IKDAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 23:00:31 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:55089 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3IKDAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 23:00:30 -0400
MIME-Version: 1.0
In-Reply-To: <21039.55685.839356.195087@quad.stoffel.home>
References: <CA+55aFyTpb8k523=qqeO9LMvs6EgmaRdohip0FcTX7Qip1VyxA@mail.gmail.com>
	<21039.55685.839356.195087@quad.stoffel.home>
Date: Tue, 10 Sep 2013 20:00:29 -0700
X-Google-Sender-Auth: 7YfOzlo4_GJFpQoyDVzLIz23qSU
Message-ID: <CA+55aFymwgUr7y_oMYRahQmtcxFLnE76LhAiD95UxBBEt=WPuA@mail.gmail.com>
Subject: Re: RIP - dead harddisk..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: John Stoffel <john@stoffel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@linux.intel.com>, Guenter Roeck <linux@roeck-us.net>,
        Dave Airlie <airlied@linux.ie>, Bruce Fields <bfields@fieldses.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 7:46 PM, John Stoffel <john@stoffel.org> wrote:
>
> Linus> The timing absolutely sucks, but it looks like the SSD in my
> Linus> main workstation just died on me.
>
> What model, if you care to share?  I figure you'r a perfect storm of
> SSD beating with all your compiles and git pulls, etc.

So I don't want to necessarily blame the harddisk, since it's just ten
days since I upgraded the rest of my machine, after it worked years in
the previous one. That just makes me go "hmm". As far as I know, all
the fans etc were working fine, but..

> And may I suggest that you get TWO of them next time and mirror them,
> for just this case?  The SysAdmin in my shouting out here...

I long ago gave up on doing backups. I have actively moved to a model
where I use replacable machines instead. I've got the stuff I care
about generally on a couple of different machines, and then keys etc
backed up on a separate encrypted USB key.

So it's inconvenient. Mainly from a timing standpoint. But nothing more.

                 Linus
