Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab3KCUCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 15:02:33 -0500
Received: from imap.thunk.org ([74.207.234.97]:53838 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab3KCUCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 15:02:32 -0500
Date: Sun, 3 Nov 2013 15:02:27 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: andreas.thalhammer@linux.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Re for el_es: A Desktop Linux idea: modulized open hardware
 database for the linux kernel config
Message-ID: <20131103200227.GC7376@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	andreas.thalhammer@linux.com, linux-kernel@vger.kernel.org
References: <201311031553.26488.andreas.thalhammer@linux.com>
 <20131103161819.GA4983@linux>
 <201311031743.26688.andreas.thalhammer@linux.com>
 <201311031957.29584.andreas.thalhammer@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201311031957.29584.andreas.thalhammer@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 07:57:29PM +0100, andreas.thalhammer@linux.com wrote:
> 
> I’m sorry, but I cannot possibly do this all by myself. I was able
> to help in some Wikis and in Smolt, but I cannot setup such a
> system. Apparently I was only able to come up with the idea...

It's an idea that people have tossed around before, but utltimately,
it's far more work than it's worth, and it's a maintenance nightmare.
For most non-technical users, using a distro kernel is quite good
enough.

For power users, they have no trouble configuring their own custom
kernel --- they can start with a full distribution kernel config, run
"make localmodconfig" which will compile a kernel with the currently
loaded modules (which are presumably the ones required for your
hardware) compiled into the kernel, and then the power user can then
disable those modules that he or she does't think they'll ever need.

The set of people who aren't willing to use a distribution kernel, but
aren't clueful enough to figure out how to customize their own kernel,
is a pretty small set.  And it's certainly not big enough such that
those of us who could implement such an idea would think that it's
worth the huge amount of effort it would require, and how to deal with
the enusing support burden when clueless end-users try to use it, and
then complain when the information is out of date.

If you told me that you wanted to try it, I would tell you that you
were going to be getting into a huge amount of work, and it's not
obvious to me that it's worth it --- but if you are going to volunteer
your own time, then it's ultimately up to you.  But having you trying
to volunteer *other* people's time for what might be a sisyphean does
take a fair amount of chutzpah.

Regards,

					- Ted
