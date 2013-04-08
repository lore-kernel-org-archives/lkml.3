Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936295Ab3DHKJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:09:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58699 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935684Ab3DHKJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:09:46 -0400
Message-ID: <51629766.6030805@gmail.com>
Date: Mon, 08 Apr 2013 12:09:42 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Pull request] bcache data offset
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
These patches update the bcache superblock format so that backing device 
data can be at an arbitrary offset from the start of the backing device; 
this helps convert partitions or logical volumes to bcache in-place, and 
<https://github.com/g2p/blocks> has been updated to use the new format.

The kernel half is on top of bcache-for-upstream, the bcache-tools half 
is on top of the development version of bcache-tools.
They can be pulled from
- https://github.com/g2p/linux/tree/bcache-for-upstream
- https://github.com/g2p/bcache-tools/tree/enable-data-offset
