Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3EMFMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 01:12:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46518 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3EMFMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 01:12:22 -0400
X-AuditID: cbfee68e-b7f276d000002279-68-5190763460d4
Date: Mon, 13 May 2013 05:12:20 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
To: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Tony Luck <tony.luck@gmail.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130513050958898@eunb.song
Msgkey: 20130513050958898@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130513050958898@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <3567921.21651368421937829.JavaMail.weblogic@epml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t8zHV2TsgmBBpPXyVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M81+mMxXcYK44+qKNsYHxBHMXIyeHkICKRMv/74wgtoSAicT/
	x5PZIGwxiQv31gPZXEA1yxglrvXNhCv63jidCSIxn1HiyMJHYJNYBFQlvs7eA9bNJqAt8fbL
	A1YQW1jATWLF7iZmkAYRgcVMEodaPzFBrJaXmHz6MjuIzSsgKHFy5hMWiA1KEqsuvWCBiCtL
	LL15BOokCYlZ0y+wQti8EjPan0LVy0lM+7qGGcKWljg/awMjzAuLvz+GivNLHLu9A2gvB1jv
	k/vBMGN2b/4CNV5AYuqZg1Ct6hIt1/YyQdh8EmsWvmWBGbPr1HJmmN77W+aC1TALKEpM6X7I
	DmFrSXz5sY8N3Vu8Ag4S16+dYAeFg4TAVA6JpW9fsE9gVJqFpG4WklmzkMxCVrOAkWUVo2hq
	QXJBcVJ6kZFecWJucWleul5yfu4mRkhy6NvBePOA9SHGZGCkTGSWEk3OByaXvJJ4Q2MzIwtT
	E1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwFlZueu5q1Bfd47H3
	FY90Seq5LcoP26Uu3TqglrnQcuvjrXP3dDzh+35WRUxMUX/vBueS7D//FixrbirPuf3GyHX3
	o/j4bW6/0jnMjLcFyxW0b9o24bxLld/+otWLvPXLzkeLH1zE1iZvfDPufzr7uVCrD+LLUifW
	zv5wPanyI4dDm8flF1W/lViKMxINtZiLihMBdo+hpyQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t/tGbomZRMCDR73yVhc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jPNfpjMV3GCuOPqijbGB8QRzFyMnh5CAikTL/++MILaEgInE98bpTBC2mMSFe+vZuhi5gGrm
	M0ocWfgIrIFFQFXi6+w9bCA2m4C2xNsvD1hBbGEBN4kVu5uYQRpEBBYzSRxq/cQEsUFeYvLp
	y+wgNq+AoMTJmU9YIDYoSay69IIFIq4ssfTmETaIuITErOkXWCFsXokZ7U+h6uUkpn1dwwxh
	S0ucn7WBEebSxd8fQ8X5JY7d3gG0lwOs98n9YJgxuzd/gRovIDH1zEGoVnWJlmt7oR7mk1iz
	8C0LzJhdp5Yzw/Te3zIXrIZZQFFiSvdDdghbS+LLj31s6N7iFXCQuH7tBPsERtlZSFKzkLTP
	QtKOrGYBI8sqRtHUguSC4qT0ChO94sTc4tK8dL3k/NxNjOBk9GzJDsaGC9aHGAU4GJV4eBco
	TwgUYk0sK67MPcQowcGsJMK71w0oxJuSWFmVWpQfX1Sak1p8iDEZGGsTmaVEk/OBiTKvJN7Q
	2MDY0NDS3MDU0MiCNGElcd5nrdaBQgLpiSWp2ampBalFMFuYODilGhhDLl5fcqtELlK37JJr
	mpg/+9VShanp6S56t6a8DVy6K17l4LH85ms5xgfPhEzetrdut+P5D7cXnRdyEez+nxhUIHkw
	0lfz1+V3OinrakP3Xgt7Xji71ZbfTfOure2v/ac3BTEFzb5Vt3xnWJJr7pOO3xOX7D+eV3H4
	6WQ2/f8VTf1+Dyf3Tr6nxFKckWioxVxUnAgA5U+gAooDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4D5CVcT031485


> Hi,

> Bitfields are likely to be implemented using read-modify-write semantics.
> Modifications of either b_jlist or b_jmodified must be done under lock
> since they share same uint. I guess this lock is missing somewhere.

Hi, I agree with you.  b_jlist and b_jmodified share the same unit.
I think they are separated. 
Thanks. ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
