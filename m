Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaBWS7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 13:59:22 -0500
Received: from mout.gmx.net ([212.227.15.18]:57942 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaBWS7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 13:59:21 -0500
Message-ID: <530A4504.9030106@gmx.de>
Date: Sun, 23 Feb 2014 19:59:16 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.13 hangs when I tried to start a KVM at a 32 bit stable Gentoo
References: <52DEA270.60803@gmx.de>
In-Reply-To: <52DEA270.60803@gmx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:YSHk4U+I8fQXN1oLSA+7EmLqyIJQ5DQbBBd+RBAjBEZvy1tGUWE
 lVfsmGGnchPqh4QySS+DIYjbgzKB8XUZV9JFFJ9NK0IEJBo8oX5u4vEy45YlMFnZTGvAnJS
 hr9PQ+2zshNpdrs/r68PMtGL+GdhTwAfsQ3txNBo9f1gAOH0JOThkedenlQ3KqowLtBfpRZ
 1C3EQbEflCAZMWmnqhbZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

The issue seen below is still a problem in stable 3.13.5 as well as in
latest git tree of Linus' - are there any patches flying around to
solve it ?

On 01/21/2014 05:38 PM, Toralf Förster wrote:
> Well,
> 
> sysrq at least works, the output of
> 
> $>sudo strings /var/log/messages | grep -e 'Jan 21 17:17:46' -e
> 'Jan 21 17:18:..' -e 'Jan 21 17:2[01]:..' > messages.txt
> 
> is attached - the .config is attached too.
> 
> 
> -- MfG/Sincerely Toralf Förster pgp finger print:1A37 6F99 4A9D
> 026F 13E2 4DCF C4EA CDDE 0076 E94E
> 
> 
> messages.txt
> 
> 
> Jan 21 17:17:46 n22 kernel: device vnet0 entered promiscuous mode 
> Jan 21 17:17:46 n22 kernel: br0: port 4(vnet0) entered forwarding
> state Jan 21 17:17:46 n22 kernel: br0: port 4(vnet0) entered
> forwarding state Jan 21 17:17:46 n22 kernel: IPv6:
> ADDRCONF(NETDEV_CHANGE): br0: link becomes ready Jan 21 17:17:46
> n22 kernel: cgroup: libvirtd (6355) created nested cgroup for
> controller "memory" which has incomplete hierarchy support. Nested
> cgroups may change behavior in the future. Jan 21 17:17:46 n22
> kernel: cgroup: "memory" requires setting use_hierarchy to 1 on the
> root. Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0: Error
> sending POWER_TABLE_CMD: time out after 2000ms. Jan 21 17:18:00 n22
> kernel: iwlwifi 0000:03:00.0: Current CMD queue read_ptr 129
> write_ptr 130 Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0:
> Loaded firmware version: 18.168.6.1 Jan 21 17:18:00 n22 kernel:
> iwlwifi 0000:03:00.0: 0x00000000 | OK Jan 21 17:18:00 n22 kernel:
> iwlwifi 0000:03:00.0: 0x00000000 | uPc Jan 21 17:18:00 n22 kernel:
> iwlwifi 0000:03:00.0: 0x00000000 | branchlink1 Jan 21 17:18:00 n22
> kernel: iwlwifi 0000:03:00.0: 0x00000000 | branchlink2 Jan 21
> 17:18:00 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 |
> interruptlink1 Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0:
> 0x00000000 | interruptlink2 Jan 21 17:18:00 n22 kernel: iwlwifi
> 0000:03:00.0: 0x00000000 | data1 Jan 21 17:18:00 n22 kernel:
> iwlwifi 0000:03:00.0: 0x00000000 | data2 Jan 21 17:18:00 n22
> kernel: iwlwifi 0000:03:00.0: 0x00000000 | line Jan 21 17:18:00 n22
> kernel: iwlwifi 0000:03:00.0: 0x00000000 | beacon time Jan 21
> 17:18:00 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | tsf low Jan
> 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | tsf hi 
> Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | time
> gp1 Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 |
> time gp2 Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0:
> 0x00000000 | time gp3 Jan 21 17:18:00 n22 kernel: iwlwifi
> 0000:03:00.0: 0x00000000 | uCode version Jan 21 17:18:00 n22
> kernel: iwlwifi 0000:03:00.0: 0x00000000 | hw version Jan 21
> 17:18:00 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 | board
> version Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0:
> 0x00000000 | hcmd Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0:
> 0x00000000 | isr0 Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0:
> 0x00000000 | isr1 Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0:
> 0x00000000 | isr2 Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0:
> 0x00000000 | isr3 Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0:
> 0x00000000 | isr4 Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0:
> 0x00000000 | isr_pref Jan 21 17:18:00 n22 kernel: iwlwifi
> 0000:03:00.0: 0x00000000 | wait_event Jan 21 17:18:00 n22 kernel:
> iwlwifi 0000:03:00.0: 0x00000000 | l2p_control Jan 21 17:18:00 n22
> kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_duration Jan 21
> 17:18:00 n22 kernel: iwlwifi 0000:03:00.0: 0x00000000 |
> l2p_mhvalid Jan 21 17:18:00 n22 kernel: iwlwifi 0000:03:00.0:
> 0x00000000 | l2p_addr_match Jan 21 17:18:00 n22 kernel: iwlwifi
> 0000:03:00.0: 0x00000000 | lmpm_pmg_sel Jan 21 17:18:00 n22 kernel:
> iwlwifi 0000:03:00.0: 0x00000000 | timestamp Jan 21 17:18:00 n22
> kernel: iwlwifi 0000:03:00.0: 0x00000000 | flow_handler Jan 21
> 17:18:00 n22 kernel: iwlwifi 0000:03:00.0: Start IWL Event Log
> Dump: nothing in log Jan 21 17:18:00 n22 kernel: iwlwifi
> 0000:03:00.0: set power fail, ret = -110 Jan 21 17:18:02 n22
> kernel: iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 0 
> Jan 21 17:18:02 n22 kernel: iwlwifi 0000:03:00.0: Current SW
> read_ptr 11 write_ptr 12 Jan 21 17:18:02 n22 kernel: iwl data:
> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ................ Jan 21 17:18:02 n22 kernel: iwlwifi 0000:03:00.0:
> FH TRBs(0) = 0x00000000 Jan 21 17:18:02 n22 kernel: iwlwifi
> 0000:03:00.0: FH TRBs(1) = 0x80102088 Jan 21 17:18:02 n22 kernel:
> iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000 Jan 21 17:18:02 n22
> kernel: iwlwifi 0000:03:00.0: FH TRBs(3) = 0x8030000b Jan 21
> 17:18:02 n22 kernel: iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000 
> Jan 21 17:18:02 n22 kernel: iwlwifi 0000:03:00.0: FH TRBs(5) =
> 0x00000000 Jan 21 17:18:02 n22 kernel: iwlwifi 0000:03:00.0: FH
> TRBs(6) = 0x00000000 Jan 21 17:18:02 n22 kernel: iwlwifi
> 0000:03:00.0: FH TRBs(7) = 0x00709081 Jan 21 17:18:02 n22 kernel:
> iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3 ra_tid
> 0x0000 [12,12] Jan 21 17:18:02 n22 kernel: iwlwifi 0000:03:00.0: Q
> 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0] Jan 21
> 17:18:02 n22 kernel: iwlwifi 0000:03:00.0: Q 2 is active and mapped
> to fifo 1 ra_tid 0x0000 [137,137] Jan 21 17:18:02 n22 kernel:
> iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0 ra_tid
> 0x0000 [0,0] Jan 21 17:18:02 n22 kernel: iwlwifi 0000:03:00.0: Q 4
> is active and mapped to fifo 0 ra_tid 0x0000 [0,0] Jan 21 17:18:02
> n22 kernel: iwlwifi 0000:03:00.0: Q 5 is active and mapped to fifo
> 4 ra_tid 0x0000 [0,0] Jan 21 17:18:02 n22 kernel: iwlwifi
> 0000:03:00.0: Q 6 is active and mapped to fifo 2 ra_tid 0x0000
> [0,0] Jan 21 17:18:02 n22 kernel: iwlwifi 0000:03:00.0: Q 7 is
> active and mapped to fifo 5 ra_tid 0x0000 [0,0] Jan 21 17:18:02 n22
> kernel: iwlwifi 0000:03:00.0: Q 8 is active and mapped to fifo 4
> ra_tid 0x0000 [0,0] Jan 21 17:18:02 n22 kernel: iwlwifi
> 0000:03:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000
> [130,130] Jan 21 17:18:02 n22 kernel: iwlwifi 0000:03:00.0: Q 10 is
> active and mapped to fifo 5 ra_tid 0x0000 [0,0] Jan 21 17:18:02 n22
> kernel: iwlwifi 0000:03:00.0: Q 11 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0] Jan 21 17:18:02 n22 kernel: iwlwifi
> 0000:03:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000
> [0,0] Jan 21 17:18:02 n22 kernel: iwlwifi 0000:03:00.0: Q 13 is
> inactive and mapped to fifo 0 ra_tid 0x0000 [0,0] Jan 21 17:18:02
> n22 kernel: iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0] Jan 21 17:18:02 n22 kernel: iwlwifi
> 0000:03:00.0: Q 15 is inactive and mapped to fifo 0 ra_tid 0x0000
> [0,0] Jan 21 17:18:02 n22 kernel: iwlwifi 0000:03:00.0: Q 16 is
> inactive and mapped to fifo 0 ra_tid 0x0000 [0,0] Jan 21 17:18:02
> n22 kernel: iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0] Jan 21 17:18:02 n22 kernel: iwlwifi
> 0000:03:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000
> [0,0] Jan 21 17:18:02 n22 kernel: iwlwifi 0000:03:00.0: Q 19 is
> inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]


- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMKRQQACgkQxOrN3gB26U553gD/Vi1FtZgpiQ2nXXzVID+D8jCs
G+ofHYN3Jz14y2nRWgUA/R5/jA2g5WyJ3i23FALDO/qeGHRQq4BJW1RTvTKQXvxM
=H8HV
-----END PGP SIGNATURE-----
