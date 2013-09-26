Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab3IZE1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 00:27:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13157 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3IZE1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 00:27:40 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-01-5243b7b9f235
Date: Thu, 26 Sep 2013 04:27:37 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: Re: Regression caused by commit 4bdc33ed
 ("NFSDv4.2: Add NFS v4.2 support to the NFS server")
To: Anna Schumaker <schumaker.anna@gmail.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20130926042312274@jongman.heo
Msgkey: 20130926042312274@jongman.heo
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130926042312274@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <14287980.88031380169656788.JavaMail.weblogic@epml16>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsWyRsSkSHfXducgg1c7GC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGy+s9rAXnjCs2P5rH3MC4wKiLkZNDSEBN4ubnQ4wgtoSAicTH
	IyuZIGwxiQv31rN1MXIB1SxllOi88pgdpmjO3hdQifmMEhMOnQfrYBFQlbg14TnYJDYBHYmO
	//tZQWxhgSyJlecmMoM0iAisZpRoefmGGWK1osS1pYvZQGxeAUGJkzOfsEBsUJH4vf4gUA0H
	UFxVovOrAURYQmLW9AusEDavxIz2p1DlchLTvq5hhrClJc7P2sAI88Hi74+h4vwSx27vYAIZ
	CdL75H4wzJjdm7+wQdgCElPPHIRq1ZSYdqQZyuaTWLPwLQvMmF2nljPD9N7fMhfsdWagT6Z0
	P2SHsLUkvvzYh+ErXgFHidcrfjGCgkFCYCKHxJ+GTvYJjEqzkNTNQjJrFpJZyGoWMLKsYhRN
	LUguKE5KLzLRK07MLS7NS9dLzs/dxAhMDaf/PZuwg/HeAetDjMnAOJnILCWanA9MLXkl8YbG
	ZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYMwznC/xOJyX
	73Fpve9fhiMLXBzWrXJ9+0pa6NyC5OTMJZdl2WdKfrUrcNbN1Ny2bmeBu90V49eJTaad8jmf
	/lfunRa001z37MWHQp2qMzbslSux3Lpt1dLHru8+P7HP6mZPjJ3gsN02ReuFjFHR5Y/fmrZf
	fq116dj738+5otL1Q7a8ezkxdJESS3FGoqEWc1FxIgDV+pVJIwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCKsWRmVeSWpSXmKPExsVy+t/tmbo7tzsHGTzZamZxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jJe
	Xu9hLThnXLH50TzmBsYFRl2MnBxCAmoSNz8fYgSxJQRMJObsfcEGYYtJXLi3HsjmAqqZzygx
	4dB5JpAEi4CqxK0Jz8Ea2AR0JDr+72cFsYUFsiRWnpvIDNIgIrCaUaLl5RtmiA2KEteWLgab
	yisgKHFy5hMWiA0qEr/XHwSq4QCKq0p0fjWACEtIzJp+gRXC5pWY0f4UqlxOYtrXNcwQtrTE
	+VkbGGEOXfz9MVScX+LY7R1MICNBep/cD4YZs3vzF6i/BCSmnjkI1aopMe1IM5TNJ7Fm4VsW
	mDG7Ti1nhum9v2Uu2OvMQJ9M6X7IDmFrSXz5sQ/DV7wCjhKvV/xinMAoOwtJahaS9llI2pHV
	LGBkWcUomlqQXFCclF5holecmFtcmpeul5yfu4kRnIaeLdnB2HDB+hCjAAejEg/vBWbnICHW
	xLLiytxDjBIczEoivN+MgEK8KYmVValF+fFFpTmpxYcYk4GRNpFZSjQ5H5gi80riDY2NTcxM
	TC1NLAxMzUkTVhLnfdZqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBUW++6fP7+THbPbeWuMVPfvJe
	4PqGPxE/lSVipBROiCm7Cxp/FLnx4X8tw03GYL/J7a9ZpCafyBdZoWYlVCDS7nmJTaFAa/cy
	tafrnD5bznc6LBOb9Fxv1nLL3XN1p72ae+7+/psMHu4vS5RfnJlzdvG5H2o9oj+/zvjaW/9i
	3ux/M0O81JKK9imxFGckGmoxFxUnAgCXFRN0hwMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8Q4RmVW011663

>
>------- Original Message -------
>
>Sender : Anna Schumaker<schumaker.anna@gmail.com>
>
>Date : 2013-09-25 22:52 (GMT+09:00)
>
>Title : Re: Regression caused by commit 4bdc33ed ("NFSDv4.2: Add NFS v4.2 support to the NFS server")
>
>
>
>Hi Jongman,
>
>Is the panic on your client or server?  I don't see how the patch your
>bisect led you to could cause the problem, since all it does is expand
>the minor version array on the server.  Your client doesn't have NFSD
>enabled, so this code shouldn't even be affecting it.
>
>A few questions:  what is your /etc/exports on the server?  What
>version of NFS are you using for nfsroot?
>
>Thanks!
>Anna
>
>On Wed, Sep 25, 2013 at 1:19 AM, Jongman Heo wrote:
>>
>> Hi all,
>>
>> My embedded development box fails to NFS-boot with NFS server which uses recent kernel.
>>
>> Using git bisect, I found it is caused by commit 4bdc33ed ("NFSDv4.2: Add NFS v4.2 support to the NFS server").
>>
>>
>> 1. dmesg (NFS boot failure case)
>>
>> ...
>> [    2.040893] ADDRCONF(NETDEV_UP): eth0: link is not ready
>> [    2.046207] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
>> [    2.053570] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>> [    3.055023] IP-Config: Guessing netmask 255.255.0.0
>> [    3.059979] IP-Config: Gateway not on directly connected network.
>> [    3.066330] Looking up port of RPC 100003/2 on 165.213.88.249
>> [    3.074001] Looking up port of RPC 100005/1 on 165.213.88.249
>> [    3.122878] VFS: Unable to mount root fs via NFS, trying floppy.
>> [    3.129134] VFS: Cannot open root device "nfs" or unknown-block(2,0)
>> [    3.135478] Please append a correct "root=" boot option; here are the available partitions:
>> [    3.143831] 1f00            3072 mtdblock0 (driver?)
>> [    3.148798] 1f01              64 mtdblock1 (driver?)
>> [    3.153758] 1f02              64 mtdblock2 (driver?)
>> [    3.158719] 1f03              64 mtdblock3 (driver?)
>> [    3.163682] 1f04              64 mtdblock4 (driver?)
>> [    3.168644] 1f05              64 mtdblock5 (driver?)
>> [    3.173607] 1f06              64 mtdblock6 (driver?)
>> [    3.178568] 0800       488386584 sda driver: sd
>> [    3.183099]   0801          506016 sda1
>> [    3.186927]   0802         4008217 sda2
>> [    3.190755]   0803       483869767 sda3
>> [    3.194584] b300         1880064 mmcblk0 driver: mmcblk
>> [    3.199802]   b301            4096 mmcblk0p1
>> [    3.204063]   b302          102400 mmcblk0p2
>> [    3.208330]   b303            4096 mmcblk0p3
>> [    3.212594]   b304               1 mmcblk0p4
>> [    3.216855]   b305            2048 mmcblk0p5
>> [    3.221116]   b306            2048 mmcblk0p6
>> [    3.225382]   b307            2048 mmcblk0p7
>> [    3.229644]   b308            4096 mmcblk0p8
>> [    3.233906]   b309           12288 mmcblk0p9
>> [    3.238176]   b30a           16384 mmcblk0p10
>> [    3.242524]   b30b          142336 mmcblk0p11
>> [    3.246869]   b30c         1572864 mmcblk0p12
>> [    3.251219] b320           12288 mmcblk0gp1 (driver?)
>> [    3.256272] b310           12288 mmcblk0gp0 (driver?)
>> [    3.261320] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(2,0)
>> [    3.269566] Pid: 1, comm: swapper Not tainted 2.6.35 #1
>> [    3.274776] Call Trace:
>> [    3.277232]  [<80d0db5b>] ? printk+0x1e/0x20
>> [    3.281492]  [<80d0dad1>] panic+0x65/0xd1
>> [    3.285495]  [<80eb9ce3>] mount_block_root+0x125/0x1be
>> [    3.290631]  [<809d1f6d>] ? sys_mknod+0x2d/0x30
>> [    3.295156]  [<80eb9f6d>] mount_root+0xd0/0xf2
>> [    3.299591]  [<80eba0d9>] prepare_namespace+0x14a/0x184
>> [    3.304803]  [<809c44f6>] ? sys_access+0x26/0x30
>> [    3.309411]  [<80eb9a4e>] kernel_init+0x25e/0x26e
>> [    3.314105]  [<80eb97f0>] ? kernel_init+0x0/0x26e
>> [    3.318800]  [<80903242>] kernel_thread_helper+0x6/0x10
>>
>>
>> 2. Client (my embedded box) configuration
>>   It's kernel 2.6.35 based, and has following NFS kernel configs.
>>
>> # grep NFS .config
>> CONFIG_NFS_FS=y
>> CONFIG_NFS_V3=y
>> CONFIG_NFS_V3_ACL=y
>> CONFIG_NFS_V4=y
>> # CONFIG_NFS_V4_1 is not set
>> CONFIG_ROOT_NFS=y
>> # CONFIG_NFSD is not set
>> CONFIG_NFS_ACL_SUPPORT=y
>> CONFIG_NFS_COMMON=y
>>
>>
>> 3. Server (NFSD) configuration
>>    Fedora 19 + latest linus git kernel 3.12.0-rc2+ (commit 22356f44, mm: Place preemption point in do_mlockall() loop)
>>
>>
>> 4. workaround
>>
>> Reverting the commit 4bdc33ed resolves my issue, NFS boot is working then.
>> I've done git bisect, but lost the resulting bisect log due to sudden power loss :(.
>>
>> Best regards,
>> Jongman Heo
>
>
>

Hi,

Please see my e-mail reply to J. Bruce Fields for the detail.

Thanks,
Jongman Heo.ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
