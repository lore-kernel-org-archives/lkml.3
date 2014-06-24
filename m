Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbaFXR20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:28:26 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39320 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbaFXR2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:28:22 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 6/6] include/rxrpc/types.h: Remove unused header
Date: Tue, 24 Jun 2014 19:27:35 +0200
Message-Id: <1403630855-29186-7-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403630855-29186-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1403630855-29186-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header file include/rxrpc/types.h does not seem to be used
anywhere. It was orphaned by 63b6be55 "[AF_RXRPC]: Delete the old
RxRPC code.". Remove it.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/rxrpc/types.h | 41 -----------------------------------------
 1 file changed, 41 deletions(-)
 delete mode 100644 include/rxrpc/types.h

diff --git a/include/rxrpc/types.h b/include/rxrpc/types.h
deleted file mode 100644
index 30d48f6..0000000
--- a/include/rxrpc/types.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/* types.h: Rx types
- *
- * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _LINUX_RXRPC_TYPES_H
-#define _LINUX_RXRPC_TYPES_H
-
-#include <linux/types.h>
-#include <linux/list.h>
-#include <linux/socket.h>
-#include <linux/in.h>
-#include <linux/spinlock.h>
-#include <linux/atomic.h>
-
-typedef uint32_t	rxrpc_seq_t;	/* Rx message sequence number */
-typedef uint32_t	rxrpc_serial_t;	/* Rx message serial number */
-typedef __be32	rxrpc_seq_net_t; /* on-the-wire Rx message sequence number */
-typedef __be32	rxrpc_serial_net_t; /* on-the-wire Rx message serial number */
-
-struct rxrpc_call;
-struct rxrpc_connection;
-struct rxrpc_header;
-struct rxrpc_message;
-struct rxrpc_operation;
-struct rxrpc_peer;
-struct rxrpc_service;
-typedef struct rxrpc_timer rxrpc_timer_t;
-struct rxrpc_transport;
-
-typedef void (*rxrpc_call_attn_func_t)(struct rxrpc_call *call);
-typedef void (*rxrpc_call_error_func_t)(struct rxrpc_call *call);
-typedef void (*rxrpc_call_aemap_func_t)(struct rxrpc_call *call);
-
-#endif /* _LINUX_RXRPC_TYPES_H */
-- 
1.9.2

