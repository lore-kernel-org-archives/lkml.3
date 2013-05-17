Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3EQOJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:09:06 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:47486 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab3EQOJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:09:04 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 17 May 2013 07:08:41 -0700
X-Google-Sender-Auth: 2dm9KIi1GWNcD0O9dqDrei7vd4E
Message-ID: <CAB=NE6VQA3fLXNeE-ihRp7sO1PDQotzmeuPGxftBFA7HzZDdPg@mail.gmail.com>
Subject: Developer Certificate of Origin - Signed-off-by standalone project followup
To: Discussion and development of copyleft-next 
	<copyleft-next@lists.fedorahosted.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "W. Trevor King" <wking@tremily.us>,
        Richard Fontana <fontana@sharpeleven.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the 2013 San Francisco Linux Collaboration talk I gave a talk [0]
as a followup on the discussions I initiated a while ago on lkml [1]
on the possibility of taking the Linux kernel's Developer Certificate
of Origin and streamlining it by making it a stand alone project for
other projects to benefit from it. This is a follow up to that talk.

W. Trevor King did some handy work by doing taking the Linux kernel's
DCO and making it a standalone project on github [2] and keeping its
history already. He's also made it project agnostic. To make a
standalone DCO project agnostic and useful for any type of project it
would help if any licensed project could use it. One question that we
had over this idea was whether or not the DCO is licensed under the
GPLv2 or not. Its arguable whether or not its copyrightable, perhaps
not but just the idea of contributions to it might make it so.
Although we could try to get a Creative Commons licensed DCO (and at
least for the standard body text, not the rest of SubmittingPatches
I'll go poke) King has made it possible for any licensed project to
use the DCO standalone project by making a Creative Commons licensed
file that simply refers to the public URL of the project.

As per discussions at LF collab it was acknowledged that the DCO could
indeed be a benefit to other projects but we'd need to ensure that the
body of the text is maintained as a very conservative document. I also
wanted to address volunteering a real life attorney to help with
reviews / maintenance so I volunteered Richard Fontana given Richard's
public work on copyleft-next and the copyleft-next mailing list
availability and his public work as an attorney for the community
there [3]. Richard seems to have accepted.

What's next? Please join the copyleft-next mailing list if you are
interested in evolving the DCO and helping with streamlining this
effort.

[0] https://docs.google.com/presentation/d/1J4VTSTuiJ88xcvOrYg7HRvwUoxOW9qvnBqOfoPPuc64/edit
[1] https://lkml.org/lkml/2012/11/20/636
[2] git://github.com/wking/signed-off-by.git
[3] http://lists.fedorahosted.org/mailman/listinfo/copyleft-next

  Luis
