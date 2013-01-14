Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3ANC30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:29:26 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:62194 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab3ANC3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:29:24 -0500
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: gregkh@linuxfoundation.org, greg@kroah.com
Cc: Cruz Julian Bishop <cruzjbishop@gmail.com>, liodot@gmail.com,
        charrer@alacritech.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Slicoss patches
Date: Mon, 14 Jan 2013 12:29:06 +1000
Message-Id: <1358130549-10969-1-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Here are three patches for Slicoss' staging driver.

It originally started as a project to remove all swearing in the Staging
drivers, but I got caught by the whitespace warnings. I don't like them :)

Sorry if I made a mistake with the second patch; I don't see how it could have
any change in functionality, but you never know. 

Thanks for looking at these.

~Cruz

Cruz Julian Bishop (3):
  staging: slicoss: Stop swearing in slicoss.c
  staging: slicoss: Fix three checkpatch.pl errors in slicoss.c
  staging: slicoss: Fix space-related checkpatch.pl warnings

 drivers/staging/slicoss/slic.h    |  504 ++++++++++++++++++-------------------
 drivers/staging/slicoss/slichw.h  |    6 +-
 drivers/staging/slicoss/slicoss.c |   35 +--
 3 files changed, 274 insertions(+), 271 deletions(-)

-- 
1.7.10.4

