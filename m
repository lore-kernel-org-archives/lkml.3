Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab3EBJ1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 05:27:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35038 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab3EBJ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 05:27:18 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-6b-5182317449e8
Date: Thu, 02 May 2013 09:27:15 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: [PATCH] MIPS: remove USB_EHCI_BIG_ENDIAN_{DESC,MMIO} depends
 on architecture symbol
To: Jonas Gorski <jogo@openwrt.org>
Cc: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "florian@openwrt.org" <florian@openwrt.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130502092239095@eunb.song
Msgkey: 20130502092239095@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130502092239095@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <6623143.198271367486832742.JavaMail.weblogic@epml20>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t8zTd0Sw6ZAgyuLVCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGlsVNTAX3OCo2d5xlbmDcw9HFyMkhJKAi0fL/OyOILSFgInH+
	3xYmCFtM4sK99WxdjFxANcsYJeY/+c8EU7T5+CUWiMR8RonJ77YwgyRYgCY9OvkVzGYT0JZ4
	++UBK4gtLJAiserzarBmEQFViU87VjGBNDML3GKUeLHhADPEGfISk09fZgexeQUEJU7OfMIC
	sU1J4vr172wQcWWJzZ/a2CDiEhKzpl9ghbB5JWa0P4Wql5OY9nUNM4QtLXF+1gZGmHcWf38M
	FeeXOHZ7B9ARHGC9T+4Hw4zZvfkL1HgBialnDkK1qkv0LjoLNZ5PYs3CtywwY3adWs4M03t/
	y1ywH5kFFCWmdD9kh7C1JL782MeG7i1eAUeJ9v2rWCYwKs9CkpqFpH0WknZkNQsYWVYxiqYW
	JBcUJ6UXGekVJ+YWl+al6yXn525ihKSGvh2MNw9YH2JMBsbJRGYp0eR8YGrJK4k3NDYzsjA1
	MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj9oH52Z572v0mCbOu
	9XgkcyWG4yEn69uzhibTOo7t/SebmbPRm+NA3aSk1+nhj4/NKjERVxCYkjktjTnl92KvCucu
	Kde+bucHyvOeX91T6H17DpvzzLxrO3d82nDV9vBF3rUCBcUznKwL3IW+FU3OdWc0veHkHaip
	VJ7qeuXbBZ3OE0tfFIYrsRRnJBpqMRcVJwIAen+Q2SMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42I5/e/2dN0Sw6ZAg1sPFSwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xpbFTUwF9zgqNnecZW5g3MPRxcjJISSgItHy/zsjiC0hYCKx+fglFghbTOLCvfVsXYxcQDXz
	GSUmv9vCDJJgAWp4dPIrmM0moC3x9ssDVhBbWCBFYtXn1UwgtoiAqsSnHauYQJqZBW4xSrzY
	cIAZYpu8xOTTl9lBbF4BQYmTM59AbVOSuH79OxtEXFli86c2Noi4hMSs6RdYIWxeiRntT6Hq
	5SSmfV3DDGFLS5yftYER5urF3x9Dxfkljt3eAXQEB1jvk/vBMGN2b/4CNV5AYuqZg1Ct6hK9
	i85CjeeTWLPwLQvMmF2nljPD9N7fMhfsR2YBRYkp3Q/ZIWwtiS8/9rGhe4tXwFGiff8qlgmM
	crOQpGYhaZ+FpB1ZzQJGllWMoqkFyQXFSekVJnrFibnFpXnpesn5uZsYwUnq2ZIdjA0XrA8x
	CnAwKvHwftBtDBRiTSwrrsw9xCjBwawkwpsk3xQoxJuSWFmVWpQfX1Sak1p8iDEZGIMTmaVE
	k/OBCTSvJN7Q2MDY0NDS3MDU0MiCNGElcd5nrdaBQgLpiSWp2ampBalFMFuYODilGhgLHtub
	xC+L3uEkF3Un0UGox3DC8cfVIR/qvi3bGtCw92Fx7oMjLqpzjbUqNF/4rAvud6xvrS6SncVx
	Mue8zIo1zwWbVGbOeq1Xl3RnjWlME+OsMwfUVnyoupGl13VR4dk+/qTopLiA7SYOayP/HvpX
	k652/0HSshdnGF14ri6cIpsSvDr38WYlluKMREMt5qLiRABpBBPglgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r429RfDo003057


>These are selects and don't prevent anyone else from also selecting
> them. If you look at your referenced commit, you see it removed the
>/depends/, not the selects. It actually added selects to several
> platforms. Platforms are supposed to select them if they need them.

Hello. 
Every time i config with arch/mips/configs/cavium_octeon_defconfig, the following warning messages 
are showed.
warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD)
warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD)

And after applying this patch, the warning messages were disappeared. 


> JonasˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
