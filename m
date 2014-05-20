Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaETN4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:56:15 -0400
Received: from tex.lwn.net ([70.33.254.29]:33323 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbaETN4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:56:14 -0400
Date: Tue, 20 May 2014 07:56:12 -0600
From: Jake Edge <jake@lwn.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Cooper <jason@lakedaemon.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Anton Saraev <antonysaraev@gmail.com>
Subject: [PATCH 0/3] staging/skein: more cleanup
Message-ID: <20140520075612.220a13ae@chukar.edge2.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Clean up a few more things in skein to get it closer to mainline
inclusion.  The first may be questionable (so I probably should have
put it last -- oh well, I can always respin), but it seemed like
putting all of the threefish block functions in one file, like the
skein block functions are all in one file, made sense.

Jake Edge (3):
  move all threefish block functions to one file, remove unneeded
    include
  fix some comment typos
  Rename a few more variables and structure member names to lower case.

 drivers/staging/skein/Makefile               |    4 +-
 drivers/staging/skein/skein.c                |  148 +-
 drivers/staging/skein/skein.h                |   34 +-
 drivers/staging/skein/skein_api.c            |   32 +-
 drivers/staging/skein/skein_api.h            |    2 +-
 drivers/staging/skein/skein_block.c          |  155 +-
 drivers/staging/skein/threefish_1024_block.c | 4902 ---------------
 drivers/staging/skein/threefish_256_block.c  | 1139 ----
 drivers/staging/skein/threefish_512_block.c  | 2225 -------
 drivers/staging/skein/threefish_api.h        |   18 +-
 drivers/staging/skein/threefish_block.c      | 8258 ++++++++++++++++++++++++++
 11 files changed, 8454 insertions(+), 8463 deletions(-)
 delete mode 100644 drivers/staging/skein/threefish_1024_block.c
 delete mode 100644 drivers/staging/skein/threefish_256_block.c
 delete mode 100644 drivers/staging/skein/threefish_512_block.c
 create mode 100644 drivers/staging/skein/threefish_block.c

-- 
1.9.0

