Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaA0Slv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:41:51 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:41511 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbaA0Slu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:41:50 -0500
Subject: Re: [BISECTED] OMAP: DSS: clk rate mismatch
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: tomi.valkeinen@ti.com,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        Tero Kristo <t-kristo@ti.com>, Nishanth Menon <nm@ti.com>
In-Reply-To: <52E697C0.6000202@gmail.com>
References: <52E697C0.6000202@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jan 2014 19:41:44 +0100
Message-ID: <1390848104.4936.62.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-27 at 19:30 +0200, Ivaylo Dimitrov wrote:
> linux-next-20140124 DSS is broken on N900  - display stays black (there 
> is some noise though). I booted the kernel with qemu and it gives the 
> following warning:
> 
> [    0.623779] DSS: set fck to 172800000
> [    0.624237] ------------[ cut here ]------------
> [    0.624298] WARNING: CPU: 0 PID: 1 at 
> drivers/video/omap2/dss/dss.c:497 dss_set_fck_rate+0x68/0x8c()
> [    0.624359] clk rate mismatch: 288000000 != 172800000

Here are also clock regressions since next-20140122 regarding
dss_set_fck_rate() and sys_clkout2 occuring in my current patchset for a
dm37xx100 board. Please see here:

 [PATCH v3 0/4] ARM: add omap3 INCOstartec board support
 http://thread.gmane.org/gmane.linux.ports.arm.omap/110095


 Thanks
  -- chf

