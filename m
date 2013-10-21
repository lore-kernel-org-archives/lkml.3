Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3JUKuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 06:50:15 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:42849 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3JUKuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 06:50:13 -0400
MIME-Version: 1.0
From: Iago Abal <mail@iagoabal.eu>
Date: Mon, 21 Oct 2013 12:49:32 +0200
X-Google-Sender-Auth: OWnNXyDku0xpPrh6kcBDXiQqj8Y
Message-ID: <CAGbDTvqC0e0wZpEYHL2kg2wGYFfZt9gx7bQQ8cmbySWHqquWqw@mail.gmail.com>
Subject: Looking for configuration-dependent bugs in Linux
To: linux-kernel@vger.kernel.org
Cc: Iago Abal <iari@itu.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux kernel developer,

We are a group working on analysis of configurable software systems at
IT University of Copenhagen. For the next four years [1] we will study
the problem of verification in highly configurable software, and we
will focus on the Linux kernel as the prime example of configurable
software. We will therefore appreciate your advice regarding a few
questions (see below).

We are currently looking for already-fixed configuration-dependent
bugs in Linux ---the bugfix helps us to understand the underlying
cause. A good example is [2], which fixes a bug that only shows up in
PA-RISC architectures when DISCONTIGMEM is enabled. Any bug appearing
in some configurations but not in others is interesting for us (e.g. a
bug affecting PowerPC only), even though the more complex the
interaction between configuration options the more interesting is the
bug for our purpose.

As a Linux kernel developer, could you:

* remember any configuration-dependent bug?
* identify any subset of configuration options that tend to interact badly?
* spot any part of the kernel more prone to configuration-dependent bugs?

Your feedback will allow us to make our search more effective. A good
understanding of how these bugs occur in Linux will also be important
for developing subsequent techniques and tools. There is of course a
potential benefit for the Linux community: we plan to pay you back in
bug reports :-)

All your feedback is welcomed.

Thank you for your time.

Kind regards,

[1] http://variete.wikit.itu.dk/
[2] http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=91ea8207168793b365322be3c90a4ee9e8b03ed4

--
Iago Abal Rivas - http://www.iagoabal.eu
Ph.D. Fellow at IT University of Copenhagen
