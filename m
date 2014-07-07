Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaGGNqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:46:42 -0400
Received: from imap.thunk.org ([74.207.234.97]:48794 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbaGGNqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:46:40 -0400
Date: Mon, 7 Jul 2014 09:46:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Nick Krause <xerofoify@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Arm Compiler - Part 1 of Compiling Tests
Message-ID: <20140707134637.GA31174@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Nick Krause <xerofoify@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAPDOMVieG951+0chzvjmKTdpZf-fEB5mjUL9YK-rgqF3+O537w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDOMVieG951+0chzvjmKTdpZf-fEB5mjUL9YK-rgqF3+O537w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 01:22:13AM -0400, Nick Krause wrote:
> Here are my logs of the builds attached  with warnings if they succeed
> for now failing arm configs
> according to the tests here,

fs/direct-io.c: In function ‘__blockdev_direct_IO’:
fs/direct-io.c:1011:12: warning: ‘to’ may be used uninitialized in this
function [-Wmaybe-uninitialized]
    u = (to - from) >> blkbits;

OK, do you see why this is a false positive?  And why asking the
thousands of people "in the commmunity" to all do exactly the same
evaluation is a massive waste of time?

And why people, after doing a quick evaluation to determine that the
very first warning you sent out (which was repeated multiple times in
your log; you didn't even bother to winnow out duplicate warnings)
is a false positive, might be inclined to ignore all e-mails from
you "asking for help" in the future?

Look, it's good that you're being enthusiastic.  But you need to do
more than just send screen shots of a kernel bugzilla where it's
already been explained to you that darned few people care about the
open/closed statistics, or running builds to complain about warnings.

If you want to send a patch to clean up the warning, figure out how to
do that, and then to send the to the right people.  (Hint: reading the
Documentation/SubmittingPatches and Documentation/Submitchecklist
files.)

Regards,

						- Ted
