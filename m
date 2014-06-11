Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaFKP5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:57:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59555 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaFKP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:57:53 -0400
From: Gideon Israel Dsouza <gidisrael@gmail.com>
To: paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        akpm@linux-foundation.org
Cc: geert@linux-m68k.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gideon Israel Dsouza <gidisrael@gmail.com>
Subject: [PATCH] security: Use macros from compiler.h instead of gcc specific attributes  
Date: Wed, 11 Jun 2014 21:25:29 +0530
Message-Id: <1402502130-26400-1-git-send-email-gidisrael@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE: Please ignore the earlier similar emails. I apologize sincerely
for the mistake.

To increase compiler portability there is <linux/compiler.h> which
provides convenience macros for various gcc constructs.  Eg: __weak for
__attribute__((weak)).

I've taken up the job of cleaning these attributes all over the kernel.
Currently my patches for cleanup of all files under /kernel, /block and
/mm are already done and in the linux 3.15 tree.

In the following patch I've replaced all aforementioned instances under
the /security directory in the kernel source.


Gideon Israel Dsouza (1):
  security: Used macros from compiler.h instead of __attribute__((...))

 security/selinux/include/security.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.9.3

