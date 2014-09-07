Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaIGJjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 05:39:22 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:33422 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaIGJjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 05:39:21 -0400
MIME-Version: 1.0
Date: Sun, 7 Sep 2014 04:39:19 -0500
Message-ID: <CAMXhOsrZfqvB3YDvdATwBAd9OJCxuAZWkdukenzLp4VKyZ_Svw@mail.gmail.com>
Subject: Error in scripts/checkpatch.pl
From: Daniel Bomar <dbdaniel42@gmail.com>
To: apw@canonical.com, joe@perches.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I'm new to all this so please correct me if I'm sending this to
the wrong place.  I'd like to report the following error that shows
whenever I run scripts/checkpatch.pl.  The error shows at the top of
the output after which the script appears to function normally.  I'm
running Arch Linux and Perl version 5.20.0.  The error is as follows:

Useless use of greediness modifier '+' in regex; marked by <-- HERE in
m/(^\+.*) {8,8}+ <-- HERE \t/ at scripts/checkpatch.pl line 2424.
