Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaDRQJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:09:25 -0400
Received: from smtpout2.laposte.net ([193.253.67.227]:32547 "EHLO
	smtpout.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaDRQJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:09:22 -0400
Date: Fri, 18 Apr 2014 18:09:18 +0200
From: Bastien Armand <armand.bastien@laposte.net>
To: Willy Tarreau <willy@meta-x.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] staging: panel: fix sparse warnings.
Message-ID: <20140418160918.GA1258@plop.dartybox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serie of two patch fix the following sparse warnings in panel.c :
panel.c:1235:26: warning: incorrect type in argument 1 (different address spaces)
panel.c:1235:26:    expected void const volatile [noderef] <asn:1>*<noident>
panel.c:1235:26:    got char const *tmp
panel.c:1353:20: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
panel.c:1353:20:    expected int ( *write )( ... )
panel.c:1353:20:    got int ( static [toplevel] *<noident> )( ... )
panel.c:1591:17: warning: incorrect type in argument 1 (different address spaces)
panel.c:1591:17:    expected void const volatile [noderef] <asn:1>*<noident>
panel.c:1591:17:    got char *tmp
panel.c:1620:20: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
panel.c:1620:20:    expected int ( *read )( ... )
panel.c:1620:20:    got int ( static [toplevel] *<noident> )( ... )

Changes since v1 :
- splitted patch in two

Bastien Armand (2):
  staging: panel: fix sparse warnings in keypad_read
  staging: panel: fix sparse warnings in lcd_write

 drivers/staging/panel/panel.c |  209 ++++++++++++++++++++++-------------------
 1 file changed, 111 insertions(+), 98 deletions(-)

--
1.7.10.4

