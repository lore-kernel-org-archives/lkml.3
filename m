Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab3BYW2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:28:38 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:64829 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab3BYW2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:28:32 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20130225141234.99b76738.akpm@linux-foundation.org>
References: <1361786813-14652-1-git-send-email-avagin@openvz.org> <20130225141234.99b76738.akpm@linux-foundation.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 25 Feb 2013 23:28:11 +0100
Message-ID: <CAKgNAkhoK4KQ-5PC+C=g1i+J7WQsdvOWFiJ9PiqD26EdCZW0OA@mail.gmail.com>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 from a queue (v2)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-api@vger.kernel.org,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pedro Alves <palves@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please, document the interface *completely* so that others can review
> the design and can then check that the implementation matches that
> design.  As it stands, we're reduced to mind-reading.

+1.

Andrey, please don't assume that people have read past mails. Even if
they have, they're forgetful. Don't make people hunt down old mails to
try to put the pieces together. The changelog should include a full
description of the interface, and also the sample user-space code that
you showed at some point in another mail. That may help you get better
review, and it will certainly help make a better man page.

Cheers,

Michael
