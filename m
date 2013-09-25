Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab3IYFUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 01:20:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48674 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3IYFUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 01:20:16 -0400
X-AuditID: cbfee68e-b7f756d000004512-d6-5242728db6d9
Date: Wed, 25 Sep 2013 05:19:50 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Regression caused by commit 4bdc33ed
 ("NFSDv4.2: Add NFS v4.2 support to the NFS server")
To: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20130925050639405@jongman.heo
Msgkey: 20130925050639405@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130925050639405@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <22596229.54071380086390046.JavaMail.weblogic@epv6ml04>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSpNtb5BRk0HRNyuLyrjlsDowenzfJ
	BTBGcdmkpOZklqUW6dslcGV8fniYqaBBo6Ln2l/WBsYfal2MnBxCAmoSNz8fYgSxJQRMJA7t
	WM0MYYtJXLi3nq2LkQuoZimjxKWVfewwRTsXL2GFSMxnlFg55xsrSIJFQFVi2bt7TCA2m4CO
	RMf//WBxYYEkiWUf+8DiIgLuEtsPz2CH2KwocW3pYjYQm1dAUOLkzCcsEAtUJLYt28oKEVeV
	uLxiP9R14hIX5l6COoJXYkb7U6h6OYlpX9dAXS0tcX7WBkaYDxZ/fwwV55c4dnsH0A0cYL1P
	7gfDjNm9+QsbhC0gMfXMQahWTYnzq7qh4nwSaxa+ZYEZs+vUcmaY3vtb5oK9xQz0ypTuh+wg
	45mBetfv0kf3Fa+As0Tv6X4mULBJCPRySLx/upZpAqPSLCR1s5CMmoUwClnJAkaWVYyiqQXJ
	BcVJ6UVGesWJucWleel6yfm5mxiBaeH0v2d9OxhvHrA+xJgMjJGJzFKiyfnAtJJXEm9obGZk
	YWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsa8g2lcDsUWW6/5
	XU96sCm3fuWj2IS27+1C+cd9DA4s0Ioyqt7a5/okiW3Zdam15XtvbJ7oNss4tOmrLs/kh74d
	hScucWyYE2OZI7c//1j8vr/n2baYxNVYLbR/+YNVeS8756pr66ZlNxr7nXMScHc1W3tIt+b3
	2XfpdjsuLNsZ5qDyYd9/J3MlluKMREMt5qLiRAC5qutuIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsVy+t/tmbq9RU5BBgu7hC0u75rD5sDo8XmT
	XABjVJpNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrShuZGekYGeqZGeoXGslaGBgZEpUE1CWsbn
	h4eZCho0Knqu/WVtYPyh1sXIySEkoCZx8/MhRhBbQsBEYufiJawQtpjEhXvr2boYuYBq5jNK
	rJzzDSzBIqAqsezdPSYQm01AR6Lj/36wuLBAksSyj31gcREBd4nth2ewQyxQlLi2dDEbiM0r
	IChxcuYTFogFKhLblm1lhYirSlxesR/qCHGJC3MvsUPYvBIz2p9C1ctJTPu6hhnClpY4P2sD
	I8yhi78/horzSxy7vQPoBg6w3if3g2HG7N78hQ3CFpCYeuYgVKumxPlV3VBxPok1C9+ywIzZ
	dWo5M0zv/S1zwd5iBnplSvdDdpDxzEC963fpo/uKV8BZovd0P9MERtlZSFKzkHTPQuhGVrKA
	kWUVo2hqQXJBcVJ6hYlecWJucWleul5yfu4mRnAKerZkB2PDBetDjAIcjEo8vBz7HIOEWBPL
	iitzDzFKcDArifD6mzsFCfGmJFZWpRblxxeV5qQWH2JMBkbZRGYp0eR8YHrMK4k3NDY2MTMx
	tTSxMDA1J01YSZz3Wat1oJBAemJJanZqakFqEcwWJg5OqQZGlr7N5jtyKxQ+tfI9v7zD6tLM
	j8r/3BfvOG33f7LKrPLeB9JWwreMao4EKWT63m3auIn14su06++j1yRxvN/apSfWfSj61PnM
	0rWdJ/6a/T4Se/LjxzeblKtu+lV3+P6KfT6vcUmdWHrmx7Z/J5oZjqyccfNbeJjwow06mi+D
	InltPz1Se3blkhJLcUaioRZzUXEiAL/CdFyFAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8P5Kjud002838


Hi all,

My embedded development box fails to NFS-boot with NFS server which uses recent kernel.

Using git bisect, I found it is caused by commit 4bdc33ed ("NFSDv4.2: Add NFS v4.2 support to the NFS server").


1. dmesg (NFS boot failure case)

...
[    2.040893] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    2.046207] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[    2.053570] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    3.055023] IP-Config: Guessing netmask 255.255.0.0
[    3.059979] IP-Config: Gateway not on directly connected network.
[    3.066330] Looking up port of RPC 100003/2 on 165.213.88.249
[    3.074001] Looking up port of RPC 100005/1 on 165.213.88.249
[    3.122878] VFS: Unable to mount root fs via NFS, trying floppy.
[    3.129134] VFS: Cannot open root device "nfs" or unknown-block(2,0)
[    3.135478] Please append a correct "root=" boot option; here are the available partitions:
[    3.143831] 1f00            3072 mtdblock0 (driver?)
[    3.148798] 1f01              64 mtdblock1 (driver?)
[    3.153758] 1f02              64 mtdblock2 (driver?)
[    3.158719] 1f03              64 mtdblock3 (driver?)
[    3.163682] 1f04              64 mtdblock4 (driver?)
[    3.168644] 1f05              64 mtdblock5 (driver?)
[    3.173607] 1f06              64 mtdblock6 (driver?)
[    3.178568] 0800       488386584 sda driver: sd
[    3.183099]   0801          506016 sda1
[    3.186927]   0802         4008217 sda2
[    3.190755]   0803       483869767 sda3
[    3.194584] b300         1880064 mmcblk0 driver: mmcblk
[    3.199802]   b301            4096 mmcblk0p1
[    3.204063]   b302          102400 mmcblk0p2
[    3.208330]   b303            4096 mmcblk0p3
[    3.212594]   b304               1 mmcblk0p4
[    3.216855]   b305            2048 mmcblk0p5
[    3.221116]   b306            2048 mmcblk0p6
[    3.225382]   b307            2048 mmcblk0p7
[    3.229644]   b308            4096 mmcblk0p8
[    3.233906]   b309           12288 mmcblk0p9
[    3.238176]   b30a           16384 mmcblk0p10
[    3.242524]   b30b          142336 mmcblk0p11
[    3.246869]   b30c         1572864 mmcblk0p12
[    3.251219] b320           12288 mmcblk0gp1 (driver?)
[    3.256272] b310           12288 mmcblk0gp0 (driver?)
[    3.261320] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(2,0)
[    3.269566] Pid: 1, comm: swapper Not tainted 2.6.35 #1
[    3.274776] Call Trace:
[    3.277232]  [<80d0db5b>] ? printk+0x1e/0x20
[    3.281492]  [<80d0dad1>] panic+0x65/0xd1
[    3.285495]  [<80eb9ce3>] mount_block_root+0x125/0x1be
[    3.290631]  [<809d1f6d>] ? sys_mknod+0x2d/0x30
[    3.295156]  [<80eb9f6d>] mount_root+0xd0/0xf2
[    3.299591]  [<80eba0d9>] prepare_namespace+0x14a/0x184
[    3.304803]  [<809c44f6>] ? sys_access+0x26/0x30
[    3.309411]  [<80eb9a4e>] kernel_init+0x25e/0x26e
[    3.314105]  [<80eb97f0>] ? kernel_init+0x0/0x26e
[    3.318800]  [<80903242>] kernel_thread_helper+0x6/0x10


2. Client (my embedded box) configuration
  It's kernel 2.6.35 based, and has following NFS kernel configs.

# grep NFS .config
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_ROOT_NFS=y
# CONFIG_NFSD is not set
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y


3. Server (NFSD) configuration
   Fedora 19 + latest linus git kernel 3.12.0-rc2+ (commit 22356f44, mm: Place preemption point in do_mlockall() loop)


4. workaround

Reverting the commit 4bdc33ed resolves my issue, NFS boot is working then.
I've done git bisect, but lost the resulting bisect log due to sudden power loss :(.

Best regards,
Jongman Heo
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
