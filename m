Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab3HFPsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:48:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113Ab3HFPsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:48:52 -0400
Date: Tue, 6 Aug 2013 17:43:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH 0/1] (Was: Linux 3.11-rc4)
Message-ID: <20130806154314.GA398@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com> <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe, thanks a lot. Yes fab840f is wrong, this "bug" is already
used as a feature.

Grazvydas, I cc'ed you because I do not really understand
set_thread_context(). It does a couple of extra PTRACE_POKEUSER's
with the "Linux 2.6.33+ needs ..." comment. It would be nice if you
can check if 3.11 still needs this, in this case we probably need
some more minor fixes in this area.

In fact the first comment doesn't look right, when I look at 2.6.33
it seems that POKEUSER(DR0-DR6) should be fine without POKEUSER(DR7),
but this doesn't really matter and I can be easily wrong. Anyway
this looks like a workaround to hide kernel bugs, I will appreciate
it if you can tell if wine still needs it or not.

Oleg.

