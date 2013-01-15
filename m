Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab3AOWgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:36:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:43978 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895Ab3AOWgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Dan Mick <dan.mick@inktank.com>,
        Josh Durgin <josh.durgin@inktank.com>
Subject: [ 207/221] rbd: fix read-only option name
Date: Tue, 15 Jan 2013 10:52:14 -0800
Message-Id: <20130115185012.991177439@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

(cherry picked from commit be466c1cc36621590ef17b05a6d342dfd33f7280)

The name of the "read-only" mapping option was inadvertently changed
in this commit:

    f84344f3 rbd: separate mapping info in rbd_dev

Revert that hunk to return it to what it should be.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Dan Mick <dan.mick@inktank.com>
Reviewed-by: Josh Durgin <josh.durgin@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -388,7 +388,7 @@ enum {
 static match_table_t rbd_opts_tokens = {
 	/* int args above */
 	/* string args above */
-	{Opt_read_only, "mapping.read_only"},
+	{Opt_read_only, "read_only"},
 	{Opt_read_only, "ro"},		/* Alternate spelling */
 	{Opt_read_write, "read_write"},
 	{Opt_read_write, "rw"},		/* Alternate spelling */


