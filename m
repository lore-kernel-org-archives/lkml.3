Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918AbaLNFJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 00:09:15 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:49572 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaLNFJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 00:09:13 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-15-548d1b784690
Date: Sun, 14 Dec 2014 05:09:12 +0000 (GMT)
From: =?euc-kr?B?x+PBvri4?= <jongman.heo@samsung.com>
Subject: [3.18+] Can't boot with commit bd809af1
 ("x86: Enable PAT to use cache mode translation tables")
To: linux-kernel@vger.kernel.org
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20141214050829442@jongman.heo
Msgkey: 20141214050829442@jongman.heo
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141214050049500@jongman.heo
X-ParentMTR: 20141214050049500@jongman.heo
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <2121586292.75471418533752002.JavaMail.weblogic@epmlwas09c>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkSLdCujfEYEsTl8XlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4MqYe3UDY8E+xYpLR3axNjCeUehi5OQQElCTuPn5ECOILSFgInHl
	wWZmCFtM4sK99WxdjFxANUsZJY48W8ACU3R90SV2iMQcRomlTcuBEhwcLAKqEp9nGYDUsAmY
	SRw7/xtsqLBApsTaeVfYQGwRoJIdZ1ewQyxWlLi2dDFYnFdAUOLkzCdQ81UkmhZPZIeIq0r0
	LrnGBBGXkJg1/QIrhM0rMaP9KVS9nMS0r2ugjpaWOD9rAyPMA4u/P4aK80scu70Dao6AxNQz
	B6FqNCX+NayBmqkt0d/+ixWmftep5cwwu+5vmQt3w9aWJ2A1zED3T+l+yA5ha0l8+bEPzS8c
	QLa7xMqvXqCgkhD4yy7RdG4G2M0sQDd8m3yIZQKj4iwkLbOQjJ2FZCyymgWMLKsYRVMLkguK
	k9KLTPSKE3OLS/PS9ZLzczcxAhPD6X/PJuxgvHfA+hCjAAejEg+vRW93iBBrYllxZe4hRlOg
	1ROZpUST84HpJ68k3tDYzMjC1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYwSs8Mn71sQHHe+reIDh3hMfMal612m8ZqhvLpimTNdzU27nF9azYtSsCh0Y1jsYnc/
	03zLqTv2pXXTjJUO7nF0nbDo9Y5Tn1vjZq4ymNL3JFdOfv/Ovsqca89uP7OcEHfI9Ej2S/my
	P0kfnlYr7rrrUfnTz2dd7v8blSYvmYsESm3lf4S731diKc5INNRiLipOBAC0/X9fBwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t/tft0K6d4Qgw0/mSwu75rD5sDo8XmT
	XABjVJpNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrShuZGekYGeqZGeoXGslaGBgZEpUE1CWsbc
	qxsYC/YpVlw6sou1gfGMQhcjJ4eQgJrEzc+HGEFsCQETieuLLrFD2GISF+6tZ+ti5AKqmcMo
	sbRpOUsXIwcHi4CqxOdZBiA1bAJmEsfO/wbrFRbIlFg77wobiC0CVLLj7Ap2iPmKEteWLgaL
	8woISpyc+YQFYr6KRNPiiewQcVWJ3iXXmCDiEhKzpl9ghbB5JWa0P4Wql5OY9nUNM4QtLXF+
	1gZGmDsXf38MFeeXOHZ7B9QcAYmpZw5C1WhK/GtYAzVTW6K//RcrTP2uU8uZYXbd3zIX7oat
	LU/AapiB7p/S/ZAdwtaS+PJjH5pfOIBsd4mVX70mMMrMQpKZhaR7FpJuZDULGFlWMYqmFiQX
	FCelVxjrFSfmFpfmpesl5+duYgQnm2eLdzD+P299iFGAg1GJh9eitztEiDWxrLgy9xCjBAez
	kghv3/eeECHelMTKqtSi/Pii0pzU4kOMpsB4msgsJZqcD0yEeSXxhsbGJmYmppYmFgam5kri
	vP/P5YYICaQnlqRmp6YWpBbB9DFxcEo1MIbqmJ2OtBJsPj5z4Zxbz4IOGvN/Tgk5+mjnfAan
	SbMnS3rk3KqOffr9wI04+6ce3nxKGTnnF68zFL9cVby+MOaO0AH+VcK3w4Pc/UVj8wM4NV92
	sK9tfr/WwUx4u5BJp+rt++siszJmugf2rtn1e76E5rSvOeu/H52az6rkYHLkXs3Jz9EiwUos
	xRmJhlrMRcWJAC+BqdBMAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBE59VJi024196


Hi,

My Linux virtual machine on (Windows) VMWare workstation 10 can't boot with following commit.

commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2
Author: Juergen Gross 
Date:   Mon Nov 3 14:02:03 2014 +0100

    x86: Enable PAT to use cache mode translation tables

Unfortunately I can't see any console log.
Reverting the commit fixes my boot issue. git bisect log follows,

$ git bisect log
git bisect start
# bad: [92a578b064d0227a3a7fbbdb9e29dbab7f8d400e] Merge tag 'pm+acpi-3.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect bad 92a578b064d0227a3a7fbbdb9e29dbab7f8d400e
# good: [b2776bf7149bddd1f4161f14f79520f17fc1d71d] Linux 3.18
git bisect good b2776bf7149bddd1f4161f14f79520f17fc1d71d
# good: [6da314122ddc11936c6f054753bbb956a499d020] Merge tag 'dt-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good 6da314122ddc11936c6f054753bbb956a499d020
# good: [482a3767e5087f6e6ad2486a6655aaa5f3d59301] exit: reparent: call forget_original_parent() under tasklist_lock
git bisect good 482a3767e5087f6e6ad2486a6655aaa5f3d59301
# bad: [cbfe0de303a55ed96d8831c2d5f56f8131cd6612] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect bad cbfe0de303a55ed96d8831c2d5f56f8131cd6612
# bad: [a6b849578ef3e0b131b1ea4063473a4f935a65e9] Merge branch 'for-linus' of git://git.samba.org/sfrench/cifs-2.6
git bisect bad a6b849578ef3e0b131b1ea4063473a4f935a65e9
# bad: [c9f861c77269bc9950c16c6404a9476062241671] Merge branch 'x86-ras-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad c9f861c77269bc9950c16c6404a9476062241671
# good: [773fed910d41e443e495a6bfa9ab1c2b7b13e012] Merge branches 'x86-platform-for-linus' and 'x86-uv-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 773fed910d41e443e495a6bfa9ab1c2b7b13e012
# good: [773fed910d41e443e495a6bfa9ab1c2b7b13e012] Merge branches 'x86-platform-for-linus' and 'x86-uv-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 773fed910d41e443e495a6bfa9ab1c2b7b13e012
# good: [f439c429c320981943f8b64b2a4049d946cb492b] x86: Support PAT bit in pagetable dump for lower levels
git bisect good f439c429c320981943f8b64b2a4049d946cb492b
# good: [e3480271f59253cb60d030aa5e615bf00b731fea] x86, mce, severity: Extend the the mce_severity mechanism to handle UCNA/DEFERRED error
git bisect good e3480271f59253cb60d030aa5e615bf00b731fea
# bad: [0dbcae884779fdf7e2239a97ac7488877f0693d9] x86: mm: Move PAT only functions to mm/pat.c
git bisect bad 0dbcae884779fdf7e2239a97ac7488877f0693d9
# bad: [bd809af16e3ab1f8d55b3e2928c47c67e2a865d2] x86: Enable PAT to use cache mode translation tables
git bisect bad bd809af16e3ab1f8d55b3e2928c47c67e2a865d2
# good: [f5b2831d654167d77da8afbef4d2584897b12d0c] x86: Respect PAT bit when copying pte values between large and normal pages
git bisect good f5b2831d654167d77da8afbef4d2584897b12d0c
# first bad commit: [bd809af16e3ab1f8d55b3e2928c47c67e2a865d2] x86: Enable PAT to use cache mode translation tables

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
