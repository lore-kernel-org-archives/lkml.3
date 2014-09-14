Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaINKsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:48:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43877 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaINKs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:48:29 -0400
Message-ID: <54157282.40402@gmail.com>
Date: Sun, 14 Sep 2014 18:48:34 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        David Vrabel <david.vrabel@citrix.com>,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] drivers/xen/xenbus/xenbus_client.c: Several improvements
 for it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are all for 'xenbus_client.c', please help check when you have time,
thanks.

Chen Gang (4):
  drivers/xen/xenbus/xenbus_client.c: Remove redundancy assignment to 'addr'
  drivers/xen/xenbus/xenbus_client.c: Correct the comments for xenbus_grant_ring()
  drivers/xen/xenbus/xenbus_client.c: Remove BUG_ON() when error string trucated
  drivers/xen/xenbus/xenbus_client.c: Improve the failure processing for __xenbus_switch_state()

 drivers/xen/xenbus/xenbus_client.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

-- 
1.9.3
