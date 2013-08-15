Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab3HOQ3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:29:34 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:49633 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab3HOQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:29:32 -0400
From: Zach Levis <zach@zachsthings.com>
To: akpm@linux-foundation.org, oleg@redhat.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dan.carpenter@oracle.com,
        keescook@chromium.org, cody@linux.vnet.ibm.com, zml@linux.vnet.ibm.com,
        Zach Levis <zach@zachsthings.com>
Subject: [PATCH v5 0/3] fs/binfmts: Improve handling of loops 
Date: Thu, 15 Aug 2013 09:20:38 -0700
Message-Id: <1376583641-10298-1-git-send-email-zach@zachsthings.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
In-Reply-To: 1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This v5 is based off Oleg's changes from "exec: more cleanups" and "exec: minor cleanups + minor fix"

v5 is just some small fixes from Oleg and putting the test scripts into the commit message
