Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab3ITPvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:51:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3ITPve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:51:34 -0400
Date: Fri, 20 Sep 2013 21:21:29 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@dhcp193-39.pnq.redhat.com
To: linux-kernel@vger.kernel.org
Subject: Need patch review
Message-ID: <alpine.LFD.2.03.1309191948100.13498@erqung.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Hello,

NULL pointer dereference while loading initramfs
   -> https://lkml.org/lkml/2013/9/15/20

Export initial ramdisk compression config option
   -> https://lkml.org/lkml/2013/9/15/22

Could someone have a look at these patches please?

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
