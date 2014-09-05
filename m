Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbaIEDlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 23:41:53 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:38464 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaIEDlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 23:41:52 -0400
MIME-Version: 1.0
Date: Fri, 5 Sep 2014 11:41:51 +0800
Message-ID: <CAFx2hwSeBijAjcUBWZOhRrFa8CkvDLFe=JtgPneVUWh=ekLoxw@mail.gmail.com>
Subject: [PATCH] openvswitch: Remove redundant comment in file net/openvswitch/vport.h
From: Lawrance Jing <lawrancejing@gmail.com>
To: dev@openvswitch.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: lawrancejing <lawrancejing@gmail.com>

In file net/openvswitch/vport.h, line#35 and line#37 are the same,
the patch will remove one to make code more clean.

Signed-off-by: lawrancejing <lawrancejing@gmail.com>
---


--- net/openvswitch/vport.h.orig 2014-08-22 02:45:36.474929300 +0800
+++ net/openvswitch/vport.h 2014-08-22 02:46:15.041929282 +0800
@@ -34,7 +34,6 @@ struct vport_parms;

 /* The following definitions are for users of the vport subsytem: */

-/* The following definitions are for users of the vport subsytem: */
 struct vport_net {
  struct vport __rcu *gre_vport;
 };
