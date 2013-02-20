Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607Ab3BTSRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:17:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933919Ab3BTSRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:17:47 -0500
Date: Wed, 20 Feb 2013 13:17:32 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/platform changes for v3.9
Message-ID: <20130220181732.GA20870@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20130219154128.GA15608@gmail.com>
 <CA+55aFxn=xFGhF8L2pJYP8wOe3VdCpGtaibB0bbRuH8FAKkCNg@mail.gmail.com>
 <CA+55aFzE_BtpN8LWbZbScF7=1P9oh0mvqRjESHLWmQHrKEvJsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzE_BtpN8LWbZbScF7=1P9oh0mvqRjESHLWmQHrKEvJsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 09:15:31AM -0800, Linus Torvalds wrote:
 > On Tue, Feb 19, 2013 at 10:39 PM, Linus Torvalds
 > <torvalds@linux-foundation.org> wrote:
 > >
 > > My main desktop just had a reboot failure - it just got stuck at the
 > > end, not powering down, and not rebooting like it should have.
 > 
 > Ok, it doesn't seem to be repeatable, so I'm going to ignore it until
 > it happens again.

FWIW, I just saw this happen too on an AMD box running your tree as of
ece8e0b2f9c980e5511fe8db2d68c6f1859b9d83

Not going to have time to bisect it though, due to travel.

	Dave

