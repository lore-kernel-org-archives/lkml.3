Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaHYKZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:25:34 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64804 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbaHYKZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:25:33 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/2] modpost: small size reduction
Date: Mon, 25 Aug 2014 12:25:14 +0200
Message-Id: <1408962316-19921-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

the following two patches lead to a small size reduction of modpost.

Please apply!

Thanks,
Mathias


Mathias Krause (2):
  modpost: reduce visibility of symbols and constify r/o arrays
  modpost: simplify file name generation of *.mod.c files

 scripts/mod/modpost.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

-- 
1.7.10.4

