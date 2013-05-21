Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3EUWg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:36:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51188 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3EUWg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:36:56 -0400
X-AuditID: cbfee68f-b7f436d000000f81-9b-519bf70638d8
Date: Tue, 21 May 2013 22:36:54 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: kbuild: warning with cavium_octeon_defconfig
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jogo@openwrt.org" <jogo@openwrt.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130521222823985@eunb.song
Msgkey: 20130521222823985@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130521222823985@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <25974545.244221369175813052.JavaMail.weblogic@epml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+Zti7b99mBBvO/8lpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M5RuPsxc8YK2YdnghUwPjCdYuRk4OIQEViZb/3xlBbAkBE4ll
	fztZIGwxiQv31rN1MXIB1SxjlGj+fZgFpuj7rB0sEIn5jBKvdjxi72Lk4GARUJV41C4JUsMm
	oC3x9ssDsAXCAmYSK16fYwKxRQTEJV7/m80K0sss0M8o0X3sDQvEFfISk09fZgexeQUEJU7O
	fAK1TEli8uejbBBxZYltH/dCXSohMWv6BVYIm1diRvtTqHo5iWlf1zBD2NIS52dtYIT5ZvH3
	x1Bxfoljt3cwgdwM0vvkfjDMmN2bv7BB2AISU88chGpVl5jS95gdwuaTWLPwLQvMmF2nljPD
	9N7fMhfsR2YBRYkp3Q/ZIWwtiS8/9rGhe4tXwEni3K9P7BMYlWchSc1C0j4LSTuymgWMLKsY
	RVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQhJD/w7GuwesDzEmA6NkIrOUaHI+MLHklcQbGpsZ
	WZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFR9e0au8lWoSHR
	22O9rxa6P/iWqFYurawVfLswQaJC7t6Jr9zT9x/o5HDjaszd7+lnbvy4hHGTz9SaTVtCRavm
	J73c8XqN5U/9WX/eM3K86fjaFHpxXuNxuxNHl7oYPlOdJq7i+G3znX/Xvr08d6DbsO2i2Ufj
	xJnyn67qOl1x/ZrR63/ks0+MEktxRqKhFnNRcSIAQiaz6SIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2DF2277MDDVoauC0u75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xvKNx9kLHrBWTDu8kKmB8QRrFyMnh5CAikTL/++MILaEgInE91k7WCBsMYkL99azdTFyAdXM
	Z5R4teMRexcjBweLgKrEo3ZJkBo2AW2Jt18egM0RFjCTWPH6HBOILSIgLvH632xWkF5mgX5G
	ie5jb1gglslLTD59mR3E5hUQlDg58wnUMiWJyZ+PskHElSW2fdwLdZCExKzpF1ghbF6JGe1P
	oerlJKZ9XcMMYUtLnJ+1gRHm6MXfH0PF+SWO3d7BBHIzSO+T+8EwY3Zv/sIGYQtITD1zEKpV
	XWJK32N2CJtPYs3CtywwY3adWs4M03t/y1ywH5kFFCWmdD9kh7C1JL782MeG7i1eASeJc78+
	sU9glJuFJDULSfssJO3IahYwsqxiFE0tSC4oTkqvMNIrTswtLs1L10vOz93ECE5RzxbtYPx3
	3voQowAHoxIP74Pa2YFCrIllxZW5hxglOJiVRHgNrwGFeFMSK6tSi/Lji0pzUosPMSYDI3Ai
	s5Rocj4wfeaVxBsaGxgbGlqaG5gaGlmQJqwkzvus1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+NL
	zwy7U7KTGm96618045t4wGy+weQJO94xMdaI8W5f/ptz7jfBi30R/CbGT5v/c+RrfTZs0t5x
	Zs0Fp4e3qjakn/xh4ZAvGd1Vf7Vny+8Z7yQiv7/M2vnPrDr//8PvKo2CrYF+64/OrDq6ss3j
	yTcp508sE92+8Xz4oSP0dEU4m23Sm/s/rrAqsRRnJBpqMRcVJwIAWMAGApUDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4LMb2YA023772


Hello. 
Every time i config with arch/mips/configs/cavium_octeon_defconfig, the following warning messages are showed.
warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD)
warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD)


I guess it caused by commit id: 9296d94d83649e1c2f25c87dc4ead9c2ab073305 

Thanks.ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
