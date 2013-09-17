Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab3IQQx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:53:58 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:48524 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab3IQQxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:53:55 -0400
X-Greylist: delayed 1151 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Sep 2013 12:53:55 EDT
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 0/3] misc N_TTY termios fixes
Date: Tue, 17 Sep 2013 12:53:33 -0400
Message-Id: <1379436816-14740-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

These 3 patches correct non-critical issues in n_tty_set_termios().
Please apply for linux-next.

Thanks,

Peter Hurley (3):
  n_tty: Remove superfluous reader wakeup
  n_tty: Remove unnecessary local variable
  n_tty: Style fix in n_tty_set_termios

 drivers/tty/n_tty.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

-- 
1.8.1.2

