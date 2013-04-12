Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab3DLUWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 16:22:15 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:39792 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab3DLUWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:22:13 -0400
From: D M German <dmg@uvic.ca>
To: stable@vger.kernel.org
Subject: helping with tracking commits across repos
Organization: University of Victoria
cc: linux-kernel@vger.kernel.org
Reply-To: dmg@uvic.ca
Date: Fri, 12 Apr 2013 13:22:09 -0700
Message-ID: <87r4ifxzwu.fsf@mn.cs.uvic.ca>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Everybody,

I am professor of computer science at the University of Victoria
(Canada).

During the last year and a half, we have been trying to track the
commits as they move in the entire linux git repos ecosystem. We have
amassed a good amount of data that tell us for every commit (and in fact
for every unique patch inside a commit) where it has been and whether it
has reached linus or not ---or any other repository, as a matter of
fact.

please look at the following URLs:

http://o.cs.uvic.ca:20810/perl/cid.pl?cid=9753dfe19a85e7e45a34a56f4cb2048bb4f50e27

http://o.cs.uvic.ca:20810/perl/cid.pl?cid=55345fb9ff68e2e5c0259c814542e72aec972c02

or

http://o.cs.uvic.ca:20810/perl/cid.pl?cid=e59bcdae87ec116dde25da6d725f79fefb253693

it will give you an idea of the data we have. You can also track other
commits using the input box, if you are interested.

I wonder if this information is of use to any of you. If you have
specific needs on how you think this info (and some more we have) can be
of use, please let me know.

By the way, I'll be at the Linux Collaboration Summit next week (I am
involved with the development of SPDX). If any of you is interested to
meet, please let me know,


--daniel german
dmg@uvic.ca
http://turingmachine.org
