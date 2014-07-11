Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaGKCsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:48:21 -0400
Received: from valhalla.ausics.net ([27.33.160.23]:32839 "EHLO mail.ausics.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbaGKCsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:48:20 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2014 22:48:19 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Jul 2014 12:41:49 +1000
From: ressy66@ausics.net
To: linux-kernel@vger.kernel.org
Subject: 3.14.12 and =?UTF-8?Q?option=5Finstat=5Fcallback=20with=20=33G?=
Message-ID: <8ddd887bdb15c5caf141dbe9eb629aa7@ausics.net>
User-Agent: Roundcube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since upgrading from 3.12.24 kernel to 3.14.10, and today, .12 kernel 
log and dmesg are flooded with constant messages

option1 ttyUSB0: option_instat_callback: error -2

The device still works, it sends and receives SMS's as well,
I tried setting verbose usb debug to see if it offers any more 
explanations, but it shows nothing more.

The device is Huawei E160, but is identified as (and always has been) an 
E620

ID 12d1:1001 Huawei Technologies Co., Ltd. E620 USB Modem

Did somthing break between 3.12 and 3.14? Rather annoying at how fast 
and large kernel.log is geting.


