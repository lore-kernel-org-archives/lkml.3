Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbaIRN6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:58:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51620 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaIRN6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:58:06 -0400
Message-ID: <541AE4E9.2040904@gmail.com>
Date: Thu, 18 Sep 2014 21:58:01 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        mukesh.rathor@oracle.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3 v2] xen/xenbus: Several improvements for 'xenbus_client.c'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Please help check when you have time. Thanks.

Chen Gang (3):
  xen/xenbus: Correct the comments for xenbus_grant_ring()
  xen/xenbus: Remove BUG_ON() when error string trucated
  xen/xenbus: Improve failure processing code for __xenbus_switch_state()

 drivers/xen/xenbus/xenbus_client.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

-- 
1.9.3
