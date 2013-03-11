Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3CKRSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:18:30 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:34448 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3CKRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:18:29 -0400
Date: Mon, 11 Mar 2013 18:18:24 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: torrent hash failures since 3.9.0-rc1
Message-ID: <20130311171824.GA434@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get hash failures on "completed" torrents since 3.9.0-rc1 (Linux 3.8
seems to be fine). What happens is that the torrents apparently complete
successfully. After reboot however the hash check fails and there are
missing (or corrupted) chunks. I've tested this with two different
clients (rtorrent and aria2c) and both are affected. So I think this
might be a filesystem issue.

/dev/sda       ext4      1.4T  666G  640G  51% /var
/dev/sda on /var type ext4 (rw,noatime,data=ordered)

I use ECC memory (and there is nothing in the logs).

-- 
Markus
