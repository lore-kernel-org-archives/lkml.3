Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3JHXO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:14:28 -0400
Received: from smtprelay0009.hostedemail.com ([216.40.44.9]:33484 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755709Ab3JHXOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:14:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:355:379:541:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1593:1594:1606:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:2828:2914:3138:3139:3140:3141:3142:3355:3868:4117:4321:4385:4605:5007:6119:7652:10004:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grass30_92c318d1f215
X-Filterd-Recvd-Size: 6093
Message-ID: <1381274061.23937.10.camel@joe-AO722>
Subject: [Trivial PATCH] tty: Remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 08 Oct 2013 16:14:21 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These aren't necessary after switch and while blocks.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/tty/nozomi.c            | 6 +++---
 drivers/tty/serial/bfin_uart.c  | 4 ++--
 drivers/tty/serial/ip22zilog.c  | 2 +-
 drivers/tty/serial/max310x.c    | 2 +-
 drivers/tty/serial/pmac_zilog.c | 2 +-
 drivers/tty/serial/sunsab.c     | 2 +-
 drivers/tty/serial/sunsu.c      | 2 +-
 drivers/tty/serial/sunzilog.c   | 6 +++---
 drivers/tty/serial/ucc_uart.c   | 2 +-
 9 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index d6080c3..cd04293 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -959,7 +959,7 @@ static int receive_flow_control(struct nozomi *dc)
 		dev_err(&dc->pdev->dev,
 			"ERROR: flow control received for non-existing port\n");
 		return 0;
-	};
+	}
 
 	DBG1("0x%04X->0x%04X", *((u16 *)&dc->port[port].ctrl_dl),
 	   *((u16 *)&ctrl_dl));
@@ -1025,7 +1025,7 @@ static enum ctrl_port_type port2ctrl(enum port_type port,
 		dev_err(&dc->pdev->dev,
 			"ERROR: send flow control " \
 			"received for non-existing port\n");
-	};
+	}
 	return CTRL_ERROR;
 }
 
@@ -1805,7 +1805,7 @@ static int ntty_ioctl(struct tty_struct *tty,
 	default:
 		DBG1("ERR: 0x%08X, %d", cmd, cmd);
 		break;
-	};
+	}
 
 	return rval;
 }
diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 3c75e8e..99653e7 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -680,7 +680,7 @@ static int bfin_serial_startup(struct uart_port *port)
 		default:
 			uart_dma_ch_rx = uart_dma_ch_tx = 0;
 			break;
-		};
+		}
 
 		if (uart_dma_ch_rx &&
 			request_dma(uart_dma_ch_rx, "BFIN_UART_RX") < 0) {
@@ -765,7 +765,7 @@ static void bfin_serial_shutdown(struct uart_port *port)
 		break;
 	default:
 		break;
-	};
+	}
 #endif
 	free_irq(uart->rx_irq, uart);
 	free_irq(uart->tx_irq, uart);
diff --git a/drivers/tty/serial/ip22zilog.c b/drivers/tty/serial/ip22zilog.c
index cb3c81e..1d94205 100644
--- a/drivers/tty/serial/ip22zilog.c
+++ b/drivers/tty/serial/ip22zilog.c
@@ -832,7 +832,7 @@ ip22zilog_convert_to_zs(struct uart_ip22zilog_port *up, unsigned int cflag,
 		up->curregs[5] |= Tx8;
 		up->parity_mask = 0xff;
 		break;
-	};
+	}
 	up->curregs[4] &= ~0x0c;
 	if (cflag & CSTOPB)
 		up->curregs[4] |= SB2;
diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index b2e707a..8d71e40 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -690,7 +690,7 @@ static void max310x_handle_tx(struct uart_port *port)
 			max310x_port_write(port, MAX310X_THR_REG,
 					   xmit->buf[xmit->tail]);
 			xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
-		};
+		}
 	}
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index f87f1a0..95917ce 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -1072,7 +1072,7 @@ static void pmz_convert_to_zs(struct uart_pmac_port *uap, unsigned int cflag,
 		uap->curregs[5] |= Tx8;
 		uap->parity_mask = 0xff;
 		break;
-	};
+	}
 	uap->curregs[4] &= ~(SB_MASK);
 	if (cflag & CSTOPB)
 		uap->curregs[4] |= SB2;
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 5d6136b..380fb53 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -894,7 +894,7 @@ static int sunsab_console_setup(struct console *con, char *options)
 	case B115200: baud = 115200; break;
 	case B230400: baud = 230400; break;
 	case B460800: baud = 460800; break;
-	};
+	}
 
 	/*
 	 * Temporary fix.
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 699cc1b..db79b76 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -522,7 +522,7 @@ static void receive_kbd_ms_chars(struct uart_sunsu_port *up, int is_break)
 				serio_interrupt(&up->serio, ch, 0);
 #endif
 				break;
-			};
+			}
 		}
 	} while (serial_in(up, UART_LSR) & UART_LSR_DR);
 }
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index 135a152..45a8c6a 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -319,7 +319,7 @@ static void sunzilog_kbdms_receive_chars(struct uart_sunzilog_port *up,
 				serio_interrupt(&up->serio, ch, 0);
 #endif
 			break;
-		};
+		}
 	}
 }
 
@@ -897,7 +897,7 @@ sunzilog_convert_to_zs(struct uart_sunzilog_port *up, unsigned int cflag,
 		up->curregs[R5] |= Tx8;
 		up->parity_mask = 0xff;
 		break;
-	};
+	}
 	up->curregs[R4] &= ~0x0c;
 	if (cflag & CSTOPB)
 		up->curregs[R4] |= SB2;
@@ -1239,7 +1239,7 @@ static int __init sunzilog_console_setup(struct console *con, char *options)
 	default: case B9600: baud = 9600; break;
 	case B19200: baud = 19200; break;
 	case B38400: baud = 38400; break;
-	};
+	}
 
 	brg = BPS_TO_BRG(baud, ZS_CLOCK / ZS_CLOCK_DIVISOR);
 
diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index 8831748..2fd1e17 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -269,7 +269,7 @@ static unsigned int qe_uart_tx_empty(struct uart_port *port)
 			return 1;
 
 		bdp++;
-	};
+	}
 }
 
 /*


