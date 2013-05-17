Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab3EQAhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 20:37:00 -0400
Received: from smtp.syd.comcen.com.au ([203.23.236.77]:2508 "EHLO
	smtp.syd.comcen.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3EQAg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 20:36:59 -0400
Message-ID: <519577DD.3040204@spin.net.au>
Date: Fri, 17 May 2013 10:20:45 +1000
From: Chris Jones <chrisjones@spin.net.au>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Linux source tree size difference issue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-comcen-MailScanner-Information: Please contact the ISP for more information
X-comcen-MailScanner: Found to be clean
X-comcen-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.821, required 4, AWL 0.68, BAYES_00 -2.60, RDNS_NONE 0.10)
X-comcen-MailScanner-From: chrisjones@spin.net.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have cloned the Linux kernel source tree locally. It comes in at
approx. ~500MB. I have then created another git repository to push the
source to for my own work. I rsynced the tree locally to another
directory and now I am currently pushing it in to the new repository and
it's at 58% and is already at 525MB.

I can not understand the stark difference in source and directory size.
Running diff tells me both local source tree directories are exactly the
same.

Can anyone explain this in layman's terms?


-- 

Chris Jones

Founder and Lead Software Architect
Paradise Software
chrisjones@spin.net.au

