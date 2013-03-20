Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3CTI6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:58:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:5758 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab3CTI6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:58:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,876,1355126400"; 
   d="scan'208";a="309352773"
From: "Stern, Eli" <eli.stern@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Use same image for boards with RAM at different locations - ARM
Thread-Topic: Use same image for boards with RAM at different locations - ARM
Thread-Index: Ac4lRw24K90JXkWVRSe8qN+zjND1MgAAc/MQ
Date: Wed, 20 Mar 2013 08:57:45 +0000
Message-ID: <2F2D37999334844EBB941E4D6CB428B51A2EC2DB@HASMSX106.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have several boards that differ in the location of RAM.
I would like to use the same image for all boards.
My current understanding is that some part of the kernel startup code are position dependent.
CPU : ARM11.
Bootloader : U-Boot
Kernel: 2.6.39.3

Is this configurable somehow?
Has anyone done this?
Is it at all possible?
Can anyone point me to some info/doc on the matter?

Thanx

Eli Stern
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

