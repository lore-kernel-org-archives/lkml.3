Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaJCVbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:31:37 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:39294 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJCVbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:31:35 -0400
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, fabio.falzoi84@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] staging: rts5208: clean up coding style in rtsx_chip.c
Date: Sat,  4 Oct 2014 00:31:16 +0300
Message-Id: <cover.1412369676.git.giedrius.statkevicius@gmail.com>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>

This patch set is a general code style clean up for rtsx_chip.c. After
this patch set checkpatch.pl without --strict doesn't complain anything
about at all and with --strict it only complains about unmatched
parantheses in those few places where I can't fix them because I don't
have the hardware to test the bigger changes nor do I have enough
experience to make such bigger changes flawlessly.

Giedrius Statkevičius (5):
  staging: rts5208: combine ifs where possible
  staging: rts5208: get rid of Camel Case, remove unneeded lines and
    parantheses
  staging: rts5208: align divided lines to opening paranthesis
  staging: rts5208: divide lines to make them less than 80 characters
    long
  staging: rts5208: use ternary operators to reduce indentation level

 drivers/staging/rts5208/rtsx_chip.c | 322 +++++++++++++++---------------------
 1 file changed, 136 insertions(+), 186 deletions(-)

-- 
2.1.2

