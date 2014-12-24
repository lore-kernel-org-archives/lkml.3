Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaLXQi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:38:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34616 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaLXQi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:38:26 -0500
Date: Wed, 24 Dec 2014 17:38:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: DRAM unreliable under specific access patern
Message-ID: <20141224163823.GA17035@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It seems that it is easy to induce DRAM bit errors by doing repeated
reads from adjacent memory cells on common hw. Details are at

https://www.ece.cmu.edu/~safari/pubs/kim-isca14.pdf

. Older memory modules seem to work better, and ECC should detect
this. Paper has inner loop that should trigger this.

Workarounds seem to be at hardware level, and tricky, too.

Does anyone have implementation of detector? Any ideas how to work
around it in software?
									
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
