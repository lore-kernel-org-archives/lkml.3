Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728Ab3DHIuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 04:50:09 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:45259 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934401Ab3DHIuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 04:50:08 -0400
Message-ID: <516284B1.7060307@gmail.com>
Date: Mon, 08 Apr 2013 10:49:53 +0200
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
