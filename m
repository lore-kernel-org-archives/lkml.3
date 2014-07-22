Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaGVIMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:12:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33934 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbaGVIMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:12:09 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-e5-53ce1cd68b96
Date: Tue, 22 Jul 2014 08:12:06 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: Re: RE: [PATCH] lib : lz4 using put_unaligned_le16 instead of
 put_unaligned
To: Chanho Min <chanho.min@lge.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hyojun.im@lge.com" <hyojun.im@lge.com>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20140722080221922@eunb.song
Msgkey: 20140722080221922@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140722080221922@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <29247639.448531406016725460.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsVy+t8zTd1rMueCDWb/0LC4vGsOmwOjx+dN
	cgGMUQ2MNolFyRmZZakKqXnJ+SmZeem2SqEhbroWSgoZ+cUltkrRRgbGekamJnpGJuZ6lgax
	VkamSgp5ibmptkoVulC9SgpFyQVAtbmVxUADclL1oOJ6xal5KQ5Z+aUgl+gVJ+YWl+al6yXn
	5yoplCXmlAKNUNJPmMqYcereAZaCHfwVvyf9ZWlgbODvYuTkEBJQkWj5/50RxJYQMJGY0dTE
	BGGLSVy4t56ti5ELqGYZo8Tma/1MMEUrZq2FSsxhlJix6zk7SIJFQFVi797jzCA2m4C2xI8D
	V8FsYYEQieapU8BsEYEkiY7+WWD1zAI5EgunXWKDuEJeYvLpy2BxXgFBiZMzn7BALFOSuLvk
	ATNEXFnid9t9qEslJGZNv8AKYfNKzGh/ClUvJzHt6xpmCFta4vysDYww3yz+/hgqzi9x7PYO
	oGc4wHqf3A+GGbN78xc2CFtAYuqZg1Ct6hIH+7qgxvNJrFn4FsoWlDh9rZsZpvf+lrlMEG8p
	Skzpfgj1opbElx/72NC9xSvgJHF3Sw/7BEblWUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9CJT
	5NjexAhJhBN3MN4/YH2IcT8jME4mMkuJJucDU2leSbyhsZmRhamJqbGRuaUZhcImphYWJkZU
	EVYS501/lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTHWxIadiclakOtkxvUV3Lsy2251
	/UiXynUqsS+LTUn6/LuiPj65++Vub8NNey8fnJj01orbmdf+fB/zo0w1h45SoR1h7vMOKa04
	UyRWrFL6z+VQcvwrxw82F9z/OFrwb173KyTVdPvWMxzNi/PlC4W0rI9847wUw7eqw6J835Z1
	mf93hrKfVGIpzkg01GIuKk4EAAC3OPP3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e92v+41mXPBBlPPq1pc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jFP3DrAU7OCv+D3pL0sDYwN/FyMnh5CAikTL/++MILaEgInEillr2SBsMYkL99YD2VxANXMY
	JWbses4OkmARUJXYu/c4M4jNJqAt8ePAVTBbWCBEonnqFDBbRCBJoqN/Flg9s0COxMJpl9gg
	lslLTD59GSzOKyAocXLmExaIZUoSd5c8YIaIK0v8brsPdZCExKzpF1ghbF6JGe1PoerlJKZ9
	XcMMYUtLnJ+1gRHm6MXfH0PF+SWO3d7B1MXIAdb75H4wzJjdm79A/SggMfXMQahWdYmDfV1Q
	4/kk1ix8C2ULSpy+1s0M03t/y1wmiLcUJaZ0P4R6UUviy499bOje4hVwkri7pYd9AqPcLCSp
	WUjaZyFpR1azgJFlFaNoakFyQXFSeoWxXnFibnFpXrpecn7uJkZwinq2eAfj//PWhxgFOBiV
	eHgt5M8GC7EmlhVX5h5ilOBgVhLhbd8DFOJNSaysSi3Kjy8qzUktPsSYDIzAicxSosn5wPSZ
	VxJvaGxgbGhoaW5gamhkQZqwkjhv/K2kICGB9MSS1OzU1ILUIpgtTBycUg2MjM6cNlu/CTS+
	/nVzUcHHfbMj4pfts7+4Y/+9Se7LF3UfeOxrFF59Q9mH7dPipWY5bfVNlcp9P67ebjhkfvzQ
	1Zdx0bU82Uar77xg4cv2y8uQD9rvodZSNql4Ut+0xXJ/ZNKq6th6YrnfWK+uePybU08j4svZ
	J72x3kx7Tu202s1WpK4jtb1LiaU4I9FQi7moOBEA/xYD15UDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6M8CJqf004388


Hello. 

>Can you check if this patch fix your problem also?
Unfortunately your patch does not fix my problem. My test logs are as follow.
I did the same test with lzo compression algorithm and with my patch, and 
these work well.

debug_shell:/user> echo 1 > /sys/block/zram0/reset
debug_shell:/user> echo lz4 > /sys/block/zram0/comp_algorithm
debug_shell:/user> echo 520M > /sys/block/zram0/disksize
debug_shell:/user> mkfs.ext4 /dev/zram0
mke2fs 1.41.4 (27-Jan-2009)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
33280 inodes, 133120 blocks
6656 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=138412032
5 block groups
32768 blocks per group, 32768 fragments per group
6656 inodes per group
Superblock backups stored on blocks:
        32768, 98304

Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 25 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
debug_shell:/user> mount /dev/zram0 /mnt/
EXT4-fs (zram0): unsupported inode size: 272
mount: wrong fs type, bad option, bad superblock on /dev/zram0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so



ThanksˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
