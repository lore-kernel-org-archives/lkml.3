Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaGHDE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:04:26 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:53002 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaGHDEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:04:24 -0400
MIME-Version: 1.0
Date: Mon, 7 Jul 2014 23:04:23 -0400
Message-ID: <CAPDOMVjMpU4g5oPNHQYP2q6M-B7dxh1wPO3Nf4f=idCQcM8bfA@mail.gmail.com>
Subject: shx3_defconfig Fails
From: Nick Krause <xerofoify@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: jslaby@suse.cz,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg and others,
The build, shx3_defconfig seems to be failing. Below this message are the logs.
Please note they are pretty long as the errors were not in the same subsystems
from what I get from reading the trace.
Cheers Nick
net/ipv4/ping.c: In function ‘ping_err’:
net/ipv4/ping.c:547:37: warning: ‘code’ may be used uninitialized in
this function [-Wmaybe-uninitialized]
     harderr = icmp_err_convert[code].fatal;
                                     ^
net/ipv4/ping.c:559:11: warning: ‘type’ may be used uninitialized in
this function [-Wmaybe-uninitialized]
   harderr = pingv6_ops.icmpv6_err_convert(type, code, &err);
           ^
net/ipv4/ping.c:501:48: warning: ‘icmph’ may be used uninitialized in
this function [-Wmaybe-uninitialized]
  if (!ping_supported(family, icmph->type, icmph->code))
                                                ^
  CC      drivers/scsi/scsi_trace.o
  CC      net/ipv4/gre_offload.o
net/ipv4/ping.c: In function ‘ping_common_sendmsg’:
net/ipv4/ping.c:464:63: warning: ‘code’ may be used uninitialized in
this function [-Wmaybe-uninitialized]
  return (family == AF_INET && type == ICMP_ECHO && code == 0) ||
                                                               ^
net/ipv4/ping.c:646:11: note: ‘code’ was declared here
  u8 type, code;
           ^
net/ipv4/ping.c:678:21: warning: ‘type’ may be used uninitialized in
this function [-Wmaybe-uninitialized]
  if (!ping_supported(family, type, code))
                     ^
  CC      net/ipv4/sysctl_net_ipv4.o
  CC      drivers/scsi/sd.o
  CC      net/ipv4/proc.o
  CC      net/ipv4/xfrm4_mode_beet.o
  CC      net/ipv4/xfrm4_mode_transport.o
  CC      net/ipv4/xfrm4_mode_tunnel.o
  CC      net/ipv4/ipconfig.o
  CC      net/ipv4/inet_diag.o
  CC      net/ipv4/tcp_diag.o
  CC      net/ipv4/tcp_cubic.o
  CC      net/ipv4/xfrm4_policy.o
  CC      net/ipv4/xfrm4_state.o
  LD      drivers/scsi/scsi_mod.o
  LD      drivers/scsi/sd_mod.o
  LD      drivers/scsi/built-in.o
  CC      drivers/sh/clk/core.o
  CC      net/ipv4/xfrm4_input.o
  CC      net/ipv4/xfrm4_output.o
  CC      net/ipv4/xfrm4_protocol.o
  CC      drivers/sh/clk/cpg.o
drivers/sh/clk/cpg.c: In function ‘r8’:
drivers/sh/clk/cpg.c:41:2: warning: passing argument 1 of ‘ioread8’
discards ‘const’ qualifier from pointer target type [enabled by
default]
  return ioread8(addr);
  ^
In file included from ./arch/sh/include/asm/io.h:20:0,
                 from include/linux/io.h:22,
                 from drivers/sh/clk/cpg.c:14:
include/asm-generic/iomap.h:28:21: note: expected ‘void *’ but
argument is of type ‘const void *’
 extern unsigned int ioread8(void __iomem *);
                     ^
drivers/sh/clk/cpg.c: In function ‘r16’:
drivers/sh/clk/cpg.c:46:2: warning: passing argument 1 of ‘ioread16’
discards ‘const’ qualifier from pointer target type [enabled by
default]
  return ioread16(addr);
  ^
In file included from ./arch/sh/include/asm/io.h:20:0,
                 from include/linux/io.h:22,
                 from drivers/sh/clk/cpg.c:14:
include/asm-generic/iomap.h:29:21: note: expected ‘void *’ but
argument is of type ‘const void *’
 extern unsigned int ioread16(void __iomem *);
                     ^
drivers/sh/clk/cpg.c: In function ‘r32’:
drivers/sh/clk/cpg.c:51:2: warning: passing argument 1 of ‘ioread32’
discards ‘const’ qualifier from pointer target type [enabled by
default]
  return ioread32(addr);
  ^
In file included from ./arch/sh/include/asm/io.h:20:0,
                 from include/linux/io.h:22,
                 from drivers/sh/clk/cpg.c:14:
include/asm-generic/iomap.h:31:21: note: expected ‘void *’ but
argument is of type ‘const void *’
 extern unsigned int ioread32(void __iomem *);
                     ^
  CC      drivers/sh/intc/access.o
  LD      drivers/soc/built-in.o
  CC      drivers/sh/intc/chip.o
  LD      drivers/sh/clk/built-in.o
  CC      drivers/sh/intc/core.o
  CC [M]  net/ipv4/ip_tunnel.o
  CC      drivers/spi/spi.o
  CC      drivers/sh/intc/handle.o
  CC      drivers/sh/intc/irqdomain.o
  CC      drivers/sh/intc/virq.o
  CC [M]  net/ipv4/tunnel4.o
  LD      drivers/sh/intc/built-in.o
  CC      drivers/sh/pm_runtime.o
  LD      drivers/sh/built-in.o
  CC      drivers/tty/tty_io.o
  LD      net/ipv4/built-in.o
  CC      drivers/tty/n_tty.o
make: *** [net] Error 2
make: *** Waiting for unfinished jobs....
