Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3GOUpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:45:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:52551 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab3GOUpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:45:34 -0400
Date: Mon, 15 Jul 2013 22:45:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] x86 updates for 3.11
In-Reply-To: <51E1F988.7010700@zytor.com>
Message-ID: <alpine.DEB.2.02.1307152212290.11918@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1307131317350.11918@ionos.tec.linutronix.de> <CA+55aFwJAV7DnMAyMm+Hdp3uYrgn+BRcBS4cLGf+KGQCdhKwbg@mail.gmail.com> <51E1F988.7010700@zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jul 2013, H. Peter Anvin wrote:

> Fail on me.  I got rushed and sloppy.  I really need to automate looking
> for warnings pre-commit and not rely on Fengguang's robot.

/me too. I took it for granted that this was tested by Ingos machinery
w/o noticing that it went in just when Ingo left for a long
weekend. So in my own rush to get out for the weekend I left out my
usual smoke tests on that branch. Sorry about that.

Thanks,

	tglx


