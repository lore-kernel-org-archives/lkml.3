Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbaEKLeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 07:34:21 -0400
Received: from www85.your-server.de ([213.133.104.85]:55581 "EHLO
	www85.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805AbaEKLeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 07:34:20 -0400
X-Greylist: delayed 1808 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 May 2014 07:34:20 EDT
From: Olaf Dietsche <olaf--list.linux-kernel@olafdietsche.de>
To: linux-kernel@vger.kernel.org
Cc: Bart van der Meulen <bartvdrmeulen@gmail.com>
Subject: [PATCH] 3.3-3.14: access permission filesystem
Date: Sun, 11 May 2014 13:04:05 +0200
Message-ID: <877g5s4lwa.fsf@olafdietsche.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Authenticated-Sender: olaf@olafdietsche.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finally came around updating the accessfs module to Linux 3.14.

This patch adds a new permission managing file system. Furthermore, it
adds two modules, which make use of this file system.

One module allows granting capabilities based on user-/groupid. The
second module allows to grant access to lower numbered ports based on
user-/groupid, too.

Changes:
- Update up to 3.14
- Included patches from Bart van der Meulen
  + register accessfs with the LSM system
  + clear I_NEW flag to prevent busy inodes on umount

The patches are available at:
<http://www.olafdietsche.de/linux/accessfs/>

and at github 

<https://github.com/olafdietsche/linux-accessfs>

in the accessfs branch.

Regards, Olaf
