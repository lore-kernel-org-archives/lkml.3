Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaIPLhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:37:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39107 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaIPLhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:37:11 -0400
X-AuditID: cbfee690-f79ce6d00000115a-f7-541820e56656
From: Alim Akhtar <alim.akhtar@samsung.com>
To: gregkh@linuxfoundation.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@list.infradead.org,
        linux-kernel@vger.kernel.org, robh@kernel.org, thomas.ab@samsung.com
Subject: [PATCH] tty/serial: samsung: Add earlycon support
Date: Tue, 16 Sep 2014 17:02:43 +0530
Message-id: <1410867163-27962-1-git-send-email-alim.akhtar@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t8zY92nChIhBsf38lg0L17PZtG3pJXN
	4vKuOWwWM87vY7L4v2cHu0XHMkYHNo9NqzrZPPbPXcPuMeHvLhaPvi2rGD0+b5ILYI3isklJ
	zcksSy3St0vgytj4XalgqljF+V/3mBsYjwl1MXJwSAiYSHxe5dHFyAlkiklcuLeeDcQWEljG
	KPF6kxhMyduFPF2MXEDhRYwSH29PYIdwJjBJbNp6AKyBTUBb4u70LUwgtoiAnMST23+YQYqY
	BSYxSkyeuIsFJCEsYCXx+/VjNpCpLAKqEk92g/XyCrhLzL27iBVimYLEnEk2IK0SAt/ZJFp3
	72YGqWEREJD4NvkQC0SNrMSmA8wQN0tKHFxxg2UCo+ACRoZVjKKpBckFxUnpRSZ6xYm5xaV5
	6XrJ+bmbGCEhOmEH470D1ocYBTgYlXh4PR6JhwixJpYVV+YeYjQF2jCRWUo0OR8YCXkl8YbG
	ZkYWpiamxkbmlmZK4ryvpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamA0O90YWb9378+r
	/Ac0d7mHc4U4X3D+W714wuSib+d3BwgWFrW5uS7h2OrHF1u64MDNNXd4bxzYsjbbRDd+f23P
	1zyrc+sLGjtcJjz2na6466Om8XMx9uTnm698ksreH+V1PeE744LYD9cEVshfPTZFUtNx4wZR
	65c7drff19pUfORm56ZL+57UKbEUZyQaajEXFScCAGbRE7pMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e+xgO5TBYkQg+VbOCyaF69ns+hb0spm
	cXnXHDaLGef3MVn837OD3aJjGaMDm8emVZ1sHvvnrmH3mPB3F4tH35ZVjB6fN8kFsEY1MNpk
	pCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2gpFCWmFMK
	FApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8zY+F2pYKpYxflf95gbGI8JdTFycEgI
	mEi8XcjTxcgJZIpJXLi3nq2LkYtDSGARo8TH2xPYIZwJTBKbth5gA6liE9CWuDt9CxOILSIg
	J/Hk9h9mkCJmgUmMEpMn7mIBSQgLWEn8fv2YDWQDi4CqxJPdYL28Au4Sc+8uYoVYrCAxZ5LN
	BEbuBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo+CZ1A7GlQ0WhxgFOBiVeHg9HomH
	CLEmlhVX5h5ilOBgVhLhvfgHKMSbklhZlVqUH19UmpNafIjRFGj3RGYp0eR8YITmlcQbGpuY
	GVkamVkYmZibK4nzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpgPCc018YuxGHXGo05haE71/jd
	eLFKsy7I0vw9x5f2Xbbvlp5ZM5c5r1pLKvrDics6c/putea2MJXoHpk81S8q15VZIyBtZuGd
	haVpdalbBV1uLM5RXjGldcU9habox6kijEtsWd7/OipR9c9Z/eLiRvF3Rdm9YTunFeznWp7Y
	JZXpwOwvVjRFiaU4I9FQi7moOBEArzLKLZgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add earlycon support for the samsung serial port. This allows enabling
the samsung serial port for console when early_params are parse and processed.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 drivers/tty/serial/Kconfig          |    1 +
 drivers/tty/serial/samsung.c        |   17 +++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 5ae8608..e01c0e5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -936,6 +936,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			must already be setup and configured. Options are not
 			yet supported.
 
+		samsung,<addr>
+			Start an early, polled-mode console on a samsung serial
+			port at the specified address. The samsung serial port
+			must already be setup and configured. Options are not
+			yet supported.
+
 		smh	Use ARM semihosting calls for early console.
 
 	earlyprintk=	[X86,SH,BLACKFIN,ARM,M68k]
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 249e340..9d42ac8 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -257,6 +257,7 @@ config SERIAL_SAMSUNG_CONSOLE
 	bool "Support for console on Samsung SoC serial port"
 	depends on SERIAL_SAMSUNG=y
 	select SERIAL_CORE_CONSOLE
+	select SERIAL_EARLYCON
 	help
 	  Allow selection of the S3C24XX on-board serial ports for use as
 	  an virtual console.
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index c78f43a..f32e9c8 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -917,6 +917,7 @@ s3c24xx_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
 #ifdef CONFIG_SERIAL_SAMSUNG_CONSOLE
 
 static struct console s3c24xx_serial_console;
+static void s3c24xx_serial_console_putchar(struct uart_port *port, int ch);
 
 static int __init s3c24xx_serial_console_init(void)
 {
@@ -926,6 +927,22 @@ static int __init s3c24xx_serial_console_init(void)
 console_initcall(s3c24xx_serial_console_init);
 
 #define S3C24XX_SERIAL_CONSOLE &s3c24xx_serial_console
+static void samsung_early_write(struct console *con, const char *s, unsigned n)
+{
+	struct earlycon_device *dev = con->data;
+
+	uart_console_write(&dev->port, s, n, s3c24xx_serial_console_putchar);
+}
+
+static int __init samsung_early_console_setup(struct earlycon_device *device,
+					      const char *opt)
+{
+	if (!device->port.membase)
+		return -ENODEV;
+	device->con->write = samsung_early_write;
+	return 0;
+}
+EARLYCON_DECLARE(samsung, samsung_early_console_setup);
 #else
 #define S3C24XX_SERIAL_CONSOLE NULL
 #endif
-- 
1.7.10.4

