Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3IWOeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:34:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33146 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3IWOd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:33:59 -0400
Date: Mon, 23 Sep 2013 09:33:51 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Linux 3.12-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+55aFxg-WropC74v5ir5r9kBJKEd93fgye4oTBhw5T8e8sb+g@mail.gmail.com>
	(from torvalds@linux-foundation.org on Mon Sep 16 17:08:11 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1379946831.1974.51@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 05:08:11 PM, Linus Torvalds wrote:
> So it's been two weeks, and the merge window for 3.12 is now closed.
> 
> The git trees have been updated, the tar-balls and patches should be
> out too, and here's my "short mergelog" for the merge window: it's
> kind of like "git shortlog", except it names the person I merged from
> (_not_ necessarily the author of the actual work, but the maintainer
> who sent me the pull request) along with a very short description of
> what the pull was for.

So this log is basically:

git log v3.11..v3.12-rc1 --merges --author="Linus Torvalds" \
   | sed -n 's/ *Pull \(.*\) from \(.*\):/\2: \1/p' | sort

Only with a slightly more clever "sort"?

Rob