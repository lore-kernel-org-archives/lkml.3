Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965095Ab3HHNeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:34:00 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:44089 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965069Ab3HHNd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:33:57 -0400
Date: Thu, 8 Aug 2013 15:33:55 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hskinnemoen@gmail.com
Subject: [GIT PULL] AVR32 fix for 3.11
Message-ID: <20130808133355.GA24175@samfundet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

please pull

git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32.git for-linus

to receive the following AVR32 fix for 3.11

Cong Ding (1):
      avr32: boards/atngw100/mrmt.c: fix building error

 arch/avr32/boards/atngw100/mrmt.c | 1 -
 1 file changed, 1 deletion(-)

-- 
Best regards,
Hans-Christian Egtvedt
