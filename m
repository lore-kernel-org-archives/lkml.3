Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3KWBUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 20:20:42 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:36587 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab3KWBUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 20:20:39 -0500
Date: Fri, 22 Nov 2013 17:20:36 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 3.12.0 release
Message-ID: <20131122172036.169467a4@nehalam.linuxnetplumber.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A little late but ready and toasty warm here is iproute2 to go with
3.12.0 (aka One Giant Leap for Frogkind).

In addition to the usual build  documentation fixes, this
version includes support for ipv6 on vxlan and GRE.
As well as fair queue packet scheduler.

If you have been sitting on changes to iproute2 that are in
net-next for 3.12 merge window, please submit them now.

Iproute2 package is available at:
  http://kernel.org/pub/linux/utils/net/iproute2/iproute2-3.12.0.tar.gz

You can download the source from:
  git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git

Stay Warm!

---
Andreas Henriksson (1):
      ss: avoid passing negative numbers to malloc

Christophe Gouault (1):
      xfrm: enable to set non-wildcard mark 0 on SAs and SPs

Eric Dumazet (3):
      pkt_sched: fq: Fair Queue packet scheduler
      tc: support TCA_STATS_RATE_EST64
      htb: add support for direct_qlen attribute

Fan Du (1):
      xfrm: use memcpy to suppress gcc phony buffer overflow warning.

Hangbin Liu (1):
      ipaddrlabel: use uint32_t instead of int32_t

Jamal Hadi Salim (2):
      tc: introduce simple action
      action: typo nat fix

Nicolas Dichtel (1):
      iplink: update available type list

Nigel Kukard (1):
      Fix tc stats when using -batch mode

Petr Písař (2):
      iproute2: bridge: document mdb
      iproute2: bridge: Close file with bridge monitor file

Sami Kerola (1):
      ip: make -resolve addr to print names rather than addresses

Stefan Tomanek (1):
      ip rule: add route suppression options

Stephen Hemminger (14):
      Update kernel headers to net-next for 3.12
      Update to 3.11 net-next kernel headers
      nstat: add json output format
      Update to 3.12-rc1 headers
      nstat: revise json output
      ifstat: add json output format
      lnstat: add json output format
      lnstat, nstat, ifstat: update man pages
      tc: add default action to kernel headers
      ipv6 gre: add entry to ether types
      Fix handling of qdis without options
      htb: remove old unused duplicate qdisc name
      update kernel headers
      v3.12.0

WANG Cong (1):
      vxlan: add ipv6 support

xeb@mail.ru (2):
      iproute2: GRE over IPv6 tunnel support.
      iproute2: ip6gre: update man pages

