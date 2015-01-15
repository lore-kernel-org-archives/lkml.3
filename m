Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbbAOOzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:55:22 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:54474 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbAOOzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:55:18 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Cox <alan@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] tty: serial: 8250_core: Remove trailing whitespaces
Date: Thu, 15 Jan 2015 15:55:07 +0100
Message-Id: <3293c93689f5d8c684133a9d9952411a201609dc.1421333585.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-24537-1421333708-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-24537-1421333708-0001

No functional changes.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/tty/serial/8250/8250_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 11c66856ba2f..65e52c9109e2 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -884,7 +884,7 @@ static int broken_efr(struct uart_8250_port *up)
 	/*
 	 * Exar ST16C2550 "A2" devices incorrectly detect as
 	 * having an EFR, and report an ID of 0x0201.  See
-	 * http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-11/4812.html
+	 * http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-11/4812.html
 	 */
 	if (autoconfig_read_divisor_id(up) == 0x0201 && size_fifo(up) == 16)
 		return 1;
@@ -1239,7 +1239,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	serial_out(up, UART_LCR, save_lcr);

 	port->fifosize = uart_config[up->port.type].fifo_size;
-	old_capabilities = up->capabilities;
+	old_capabilities = up->capabilities;
 	up->capabilities = uart_config[port->type].flags;
 	up->tx_loadsz = uart_config[port->type].tx_loadsz;

--
1.8.2.3


--=_mimegpg-monstr-desktop-24537-1421333708-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlS31MwACgkQykllyylKDCEloACeIYkq59Mpy9UYhPvwNau3T4z7
EjYAnjp47cBfQPrZP9AxwJGqWynWH8Ib
=RK+E
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-24537-1421333708-0001--
