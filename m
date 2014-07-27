Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaG0LtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 07:49:01 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38333 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaG0Ls6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 07:48:58 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] s390: net: claw.c:  Fix a define larger than in a sizeof in conjunction with strncpy 
Date: Sun, 27 Jul 2014 13:50:21 +0200
Message-Id: <1406461822-11249-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tried also optimize and clarify what youare after here,
although this is a string of 7 characters, to overwrite the
dual hardly matters :)

Probably it would have been clearer to use snprintf
with "%s         "  , but the solution is a bit slower though...?

Rickard Strandqvist (1):
  s390: net: claw.c:  Fix a define larger than in a sizeof in conjunction with
    strncpy

 drivers/s390/net/claw.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

-- 
1.7.10.4

