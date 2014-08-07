Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbaHGNbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:31:38 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:39422 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434AbaHGNbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:31:36 -0400
Date: Thu, 7 Aug 2014 15:31:31 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hskinnemoen@gmail.com
Subject: [GIT PULL] AVR32 update for 3.17
Message-ID: <20140807133131.GA10311@samfundet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

please pull

git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32.git for-linus

to receive the following AVR32 update for 3.17

Julia Lawall (1):
      avr32: fix error return code

 arch/avr32/boards/hammerhead/flash.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)
-- 
mvh
Hans-Christian Egtvedt
