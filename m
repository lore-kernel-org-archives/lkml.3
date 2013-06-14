Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3FNFnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:43:51 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:64022 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3FNFnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:43:50 -0400
Message-ID: <51BAAD93.6020308@contentreich.de>
Date: Fri, 14 Jun 2013 05:43:47 +0000
From: Andreas Steffan <a.steffan@contentreich.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: TCP through vpnx dev stalls
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo everybody,

I see certain tcp traffing stalling with kernel 3.8.0-22.33 (current
Raring Ringtail version). It is 100% reproducible when I scp a file
(>100 kB) to a machine on the other side. Copying a file of any size in
the other direction (from the remote machine) to my box works fine. I
see somewhat similiar problems doing large HTTP POSTs to the remote
machine or when I run a remote X application.

I tried several versions of openconnect 4.06, 4.07 and 4.99 on linux
3.8.0-22 and see this behaviour with all versions.

On the same system everything works fine by just swapping the kernel
booting to 3.5.0-27.46 (latest from Quantal Quetzal).


Additional information (e.g. tcpdump output) is at launchpad (bug 1185884)
where I originally reported to bug.

Linux mcgyver 3.8.0-23-generic #34-Ubuntu SMP Wed May 29 20:22:58 UTC
2013 x86_64 x86_64 x86_64 GNU/Linux
 
Gnu C                  4.7
Gnu make               3.81
binutils               2.23.2
util-linux             2.20.1
mount                  support
module-init-tools      9
e2fsprogs              1.42.5
jfsutils               1.1.15
reiserfsprogs          3.6.21
xfsprogs               3.1.9
pcmciautils            018
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.20
wireless-tools         30
Modules Loaded         nls_utf8 isofs snd_hrtimer pci_stub vboxpci
vboxnetadp vboxnetflt vboxdrv nfnetlink_log nfnetlink ip6table_filter
ip6_t_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_CHECKSUM ipta_tcpudp iptable_filter ip_tables x_tables bridge stp llc
autofs4 deflate zlib_deflate dm_crypt ctr twofish_generic
twofish_x86_64_3way twofishsh_common camellia_generic camellia_x86_64
serpent_sse2_x86_64 serpent_generic glue_helper blowfish_generic

best regards
Andreas

-- 
Andreas Steffan

Achter Billing 14
22399 Hamburg
Germany

skype: contentreich
M: +49 1793903615
T: +49 40 23943542
F: +49 40 23943542

http://www.contentreich.de

Contentreich : Alfresco WCM / ECM, JEE, Grails

