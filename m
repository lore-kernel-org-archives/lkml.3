Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3EMCVL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:21:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15553 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3EMCVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:21:08 -0400
X-AuditID: cbfee690-b7efc6d000006d92-2b-51904e1249a1
Date: Mon, 13 May 2013 02:21:06 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
To: Tony Luck <tony.luck@gmail.com>, Dmitry Monakhov <dmonakhov@openvz.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130513021543843@eunb.song
Msgkey: 20130513021543843@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130513021543843@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <7032562.14371368411664268.JavaMail.weblogic@epml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Znq6Q34RAg+knZS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG7J9TGAtWcVXsmCnVwNjC1cXIySEkoCLR8v87I4gtIWAisejr
	PTYIW0ziwr31QDYXUM0yRokLf2ezwxT937EVKjGfUWLLxF9MIAkWAVWJxcffMIPYbALaEm+/
	PGAFsYUFvCRa13wCmyoiECix7MNOZpBmZoGFjBL/Ds5khzhDXmLy6ctgNq+AoMTJmU9YILYp
	SZztOsoGEVeWaN7/mgkiLiExa/oFVgibV2JG+1OoejmJaV/XMEPY0hLnZ21ghHln8ffHUHF+
	iWO3dwDN4QDrfXI/GGbM7s1foL4XkJh65iAjRIm6xLPJehBhPok1C9+ywEzZdWo5M0zr/S1z
	wS5jFlCUmNL9kB3C1pL48mMfG7qveAUcJK6cPs48gVF5FpLULCTts5C0I6tZwMiyilE0tSC5
	oDgpvchErzgxt7g0L10vOT93EyMkLUzYwXjvgPUhxmRglExklhJNzgemlbySeENjMyMLUxNT
	YyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcAIT05rKuQc+nNmrsH3Tw4Rz
	t2NP/dP04ndl1uy+oW4Qs/UV28tM5pPzzyi+Yn7KU7620lkoV8h6zdnQdY8WNwb23ZikdMs2
	6U4pr6xy+QfDVLG/EbM45X+dVkiZvpVlw5Gdsxe5HiwpebWmkyXB+uQh4+2nDu4zeblTimPC
	xwnOt+6kRyx53XbkQpASS3FGoqEWc1FxIgC6/MKLIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2DF0hvwmBBhPvSFlc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jNk/pzAWrOKq2DFTqoGxhauLkZNDSEBFouX/d0YQW0LAROL/jq1sELaYxIV764FsLqCa+YwS
	Wyb+YgJJsAioSiw+/oYZxGYT0JZ4++UBK4gtLOAl0brmE1iziECgxLIPO5lBmpkFFjJK/Ds4
	kx1im7zE5NOXwWxeAUGJkzOfsEBsU5I423WUDSKuLNG8/zUTRFxCYtb0C6wQNq/EjPanUPVy
	EtO+rmGGsKUlzs/awAhz9eLvj6Hi/BLHbu8AmsMB1vvkfjDMmN2bv0A9KSAx9cxBRogSdYln
	k/UgwnwSaxa+ZYGZsuvUcmaY1vtb5oJdxiygKDGl+yE7hK0l8eXHPjZ0X/EKOEhcOX2ceQKj
	3CwkqVlI2mchaUdWs4CRZRWjaGpBckFxUnqFoV5xYm5xaV66XnJ+7iZGcIJ6tnAH45fz1ocY
	BTgYlXh4PRUnBAqxJpYVV+YeYpTgYFYS4d3rBhTiTUmsrEotyo8vKs1JLT7EmAyMwInMUqLJ
	+cDkmVcSb2hsYGxoaGluYGpoZEGasJI479NW60AhgfTEktTs1NSC1CKYLUwcnMAU1tYrMu9J
	xCnV1FWqi462XP5bkNtd9S9/9/3zf6pmbOG46/bhYkJVvwzjlA/CQrsPWuw9nLNmqefx24qn
	wtcmnI0Xlj939wHXw9Wx/c6vFD68PCGTsFVh6tUFDccTp3fJXlmkwc7JuiPAJFfZ/FPwOQMf
	Uc4V81QnhPRuW+hzmcc3esmpmkkfzJRYijMSDbWYi4oTAbL1xjmUAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4D2LIHp030838



> CONFIG_IA64_PAGE_SIZE_64KB=y

> fsblock size is whatever is the default for SLES11SP2 on ia64 - which
> tool will tell me?

> My git bisect finally competed and points the a finger at:

> bisect> git bisect good
> ae4647fb7654676fc44a97e86eb35f9f06b99f66 is first bad commit
> commit ae4647fb7654676fc44a97e86eb35f9f06b99f66
> Author: Jan Kara 
> Date:   Fri Apr 12 00:03:42 2013 -0400

>     jbd2: reduce journal_head size

>     Remove unused t_cow_tid field (ext4 copy-on-write support doesn't seem
>     to be happening) and change b_modified and b_jlist to bitfields thus
>     saving 8 bytes in the structure.

>     Signed-off-by: Jan Kara 
>     Signed-off-by: "Theodore Ts'o" 
>     Reviewed-by: Zheng Liu 

> :040000 040000 c39ece4341894b3daf84764ba425a87ffb90fe50
> d4e8d9185c2a1b740c235ca8ed05d496a442fce3 M      include

Hi, my git bisect result is same yours. And i reported that to community yesterday.
Thanks. 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
