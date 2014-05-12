Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbaELROS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:14:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbaELROR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:14:17 -0400
Date: Mon, 12 May 2014 13:14:09 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org
Subject: Trinity 1.4 tarball release.
Message-ID: <20140512171409.GA32653@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finally got around to cutting a new release of trinity, hopefully
putting off the "are you running git, or tarball?" questions for a while.

Big changes since 1.3 include some more targetted fuzzing of VM related
syscalls, which judging from the fallout over the last six months, seems
to be working quite well.

Trinity should now also scale up a lot better on bigger machines with lots of cores.
It should pick a reasonable default number of child processes, but you
can override with -C as you could before, but now without any restrictions other
than available memory.  (I'd love to hear stories of people running it
on some of the more extreme systems, especially if something interesting broke)

Info, tarballs, and pointers to git are as always, at
http://codemonkey.org.uk/projects/trinity/

thanks to everyone who sent patches, chased down interesting kernel bugs
trinity found, or who gave me ideas/feedback. Your input has been much
appreciated.

	Dave

