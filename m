Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867Ab3BYWhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:37:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924Ab3BYWhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:37:31 -0500
Date: Mon, 25 Feb 2013 14:37:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mtk.manpages@gmail.com
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-api@vger.kernel.org,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without
 removing from a queue (v2)
Message-Id: <20130225143728.3ddb88fc.akpm@linux-foundation.org>
In-Reply-To: <CAKgNAkhoK4KQ-5PC+C=g1i+J7WQsdvOWFiJ9PiqD26EdCZW0OA@mail.gmail.com>
References: <1361786813-14652-1-git-send-email-avagin@openvz.org>
	<20130225141234.99b76738.akpm@linux-foundation.org>
	<CAKgNAkhoK4KQ-5PC+C=g1i+J7WQsdvOWFiJ9PiqD26EdCZW0OA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2013 23:28:11 +0100
"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:

> > Please, document the interface *completely* so that others can review
> > the design and can then check that the implementation matches that
> > design.  As it stands, we're reduced to mind-reading.
> 
> +1.

I suddenly feel less lonely.

> Andrey, please don't assume that people have read past mails. Even if
> they have, they're forgetful. Don't make people hunt down old mails to
> try to put the pieces together. The changelog should include a full
> description of the interface, and also the sample user-space code that
> you showed at some point in another mail.

If there's sample userspace code, there are all sorts of good reasons
for putting that into tools/testing/selftests/your-name-here/

> That may help you get better
> review, and it will certainly help make a better man page.

