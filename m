Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaJIRKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:10:35 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36438 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaJIRK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:10:27 -0400
Date: Thu, 9 Oct 2014 10:10:17 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 v3.17
Message-ID: <20141009101017.3e2d7942@urahara>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like Linus, get the 3.17 release out before leaving for Germany.

There are lots of fixes all over the place. Jamal has returned bringing
lots of updates to the TC action and classifiers.

Source:
  http://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-3.17.0.tar.gz

Repository:
  git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.

---
Andy Furniss (1):
      add missing underscore to man page and example nf_mark ematch

Atzm Watanabe (1):
      iplink: do not require assigning negative ifindex at link creation

Daniel Borkmann (1):
      ll_types: add netlink ARPHRD

Dmitry Popov (1):
      ip tunnel: fix 'ip -oneline tunnel show' for some GRE tunnels

Eric Dumazet (3):
      nstat: 64bit support on 32bit arches
      ip: support of usec rtt in tcp_metrics
      ss: add more tcp socket diagnostics

Jamal Hadi Salim (5):
      actions: BugFix action stats to display with -s
      rsvp classifier support for multiple actions
      tcindex classifier support for multiple actions
      route classifier support for multiple actions
      discourage use of direct policer interface

Jiri Benc (1):
      ip address: print stats with -s

Jiri Pirko (2):
      iproute2: allow to ipv6 set address generation mode
      add help command to bonding master

Nicolas Dichtel (2):
      ip/vxlan: add a help for ageing and maxaddress options
      ip/vxlan: fix display of maxaddress option

Nikolay Aleksandrov (1):
      iproute2: allow to change slave options via type_slave

Steffen Klassert (2):
      iproute2: Add support for IPv6 VTI tunnels to ip6tunnel
      iproute2: VTI6 support for ip -6 link command.

Stephen Hemminger (2):
      update dsfield file values
      emp: fix warning on deprecated bison directive

WANG Cong (1):
      iplink: forbid negative ifindex and modifying ifindex

vadimk (14):
      ip netns: Show error message if mkdir failed to create /var/run/netns
      ip man: Added short description for hsr link type
      ip link: Remove unnecessary device checking
      ip monitor: Dont print timestamp or banner-label for cloned routes
      ip monitor: Skip IPv6 ND user option messages
      ip tuntap: Add checking if tun/tap mode was set by default
      ip tuntap: Added missing commands in usage
      tests: Fix problem with test running
      ip netns: Create /var/run/netns dir when do 'ip netns monitor'
      ip monitor: Changed 'Unknown message' format to be more informative
      tests: Add runtime generated files to .gitignore
      tests: Allow policer test to be ran
      tests: Check existing of /proc/config.gz before use it
      ip link: Shortify printing the usage of link type

