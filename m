Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaACALv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:11:51 -0500
Received: from plane.gmane.org ([80.91.229.3]:55803 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbaACALN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:11:13 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?U8OpYmFzdGllbiBMdXR0cmluZ2Vy?= <seblu@seblu.net>
Subject: Last depmod fails with 3.13-rc6
Date: Fri, 03 Jan 2014 01:11:00 +0100
Message-ID: <la4v6a$a94$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: slice.seblu.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Trying to run depmod (from kmod 16) on the 3.13-rc6, I got this error
message:

# depmod 3.13.0-rc6-seblu
depmod: ERROR: Module 'hci_vhci' has devname (vhci) but lacks major and
minor information. Ignoring.
# echo $?
1

The message and error code seem to be on purpose[2] but they break tools
which rely on depmod return 0 (like kernel-install).

Maybe fixing this in the kernel before the release will avoid future
updates issue downstream.

[1] http://git.kernel.org/cgit/utils/kernel/kmod/kmod.git/commit/?id=6506ddf

-- 
Sébastien "Seblu" Luttringer
https://seblu.net
GPG: 0x2072D77A

