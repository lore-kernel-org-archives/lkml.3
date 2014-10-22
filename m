Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaJVGyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:54:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19166 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaJVGyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:54:22 -0400
X-AuditID: cbfee68d-f79296d000004278-31-5447549cb0d5
Date: Wed, 22 Oct 2014 06:54:20 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: Re: Re: [PATCH] mips: add arch_trigger_all_cpu_backtrace() function
To: John Crispin <blogic@openwrt.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20141022064859326@eunb.song
Msgkey: 20141022064859326@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141022064859326@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1061520101.169091413960858532.JavaMail.weblogic@epmlwas02b>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsVy+t8zLd05Ie4hBqcec1lc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMeLLmPGNBB0/FmQ8P2RsY73B3MXJyCAmoSLT8/84IYksImEgsfNLK
	BmGLSVy4tx7I5gKqWcYoMePgQ1aYosMbFzFBJOYwSkz6+xmsg0VAVeLzkv9gRWwC2hI/Dlxl
	BrGFBXwk9kz/CLZBRCBM4urhFWA2s0CNRPffxYwQV8hLTD59mR3E5hUQlDg58wkLxDIliTdn
	/rFAxJUl1l1fwwQRl5CYNf0C1EG8EjPan0LVy0lM+7qGGcKWljg/awMjzDeLvz+GivNLHLu9
	A2qOgMTUMwehatQlOqfMhprDJ7Fm4VsoW1Di9LVuZphd97fMhbtha8sTVohfFCWmdD9kh7C1
	JL782MeG7hdeAQ+J5qbrzKCAkxDo5ZB4dfYy4wRGpVlI6mYhmTULySxkNQsYWVYxiqYWJBcU
	J6UXGSLH9yZGSDLs3cF4+4D1IUYBDkYlHl4HNvcQIdbEsuLK3EOMycB4msgsJZqcD0y5eSXx
	hsZmRhamJqbGRuaWZhjCJqYWFiZGOISVxHkVpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amDU26zrLqe9r6LM9bOQ2QntSM3rMgFzH3gxJ8yN3fDToFTsUWLlndoJTrevzK1os5q2cj7H
	p5+J1l6LHyl5Trc4Y3zzZ5ZawuLnaurn+KeVxp+81MAs96Xx2xO7hrL7qsZ+KurBwVEnT0U8
	2d+mOydHnuGHhknrA7mEJd5JLqcMr+RyLWv5vl2JpTgj0VCLuag4EQAmrSqDrwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t/tft05Ie4hBs2n2S0u75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xpM15xkLOngqznx4yN7AeIe7i5GTQ0hARaLl/3dGEFtCwETi8MZFTBC2mMSFe+vZuhi5gGrm
	MEpM+vuZDSTBIqAq8XnJf1YQm01AW+LHgavMILawgI/EnukfwQaJCIRJXD28AsxmFqiR6P67
	mBFimbzE5NOX2UFsXgFBiZMzn7BALFOSeHPmHwtEXFli3fU1UEdISMyafoEVwuaVmNH+FKpe
	TmLa1zXMELa0xPlZGxhhjl78/TFUnF/i2O0dUHMEJKaeOQhVoy7ROWU21Bw+iTUL30LZghKn
	r3Uzw+y6v2Uu3A1bW56wQvyiKDGl+yE7hK0l8eXHPjZ0v/AKeEg0N11nnsAoOwtJahaS9llI
	2pHVLGBkWcUomlqQXFCclF5hqFecmFtcmpeul5yfu4kRnIyeLdzB+OW89SFGAQ5GJR5eBzb3
	ECHWxLLiytxDjBIczEoivH0WQCHelMTKqtSi/Pii0pzU4kOMpsBYm8gsJZqcD0yUeSXxhsYG
	xoaGluYGpoZGFkrivHdvJgUJCaQnlqRmp6YWpBbB9DFxcEo1MF4y31m58/E8Dnex9bucxYJO
	tG6QnfF24afD0aX6TTcPuEfGZjQ1RTFWB35pcdb78G7WJf81RzdlXUhSaBJq2ijWcTRv54rE
	Sp73DXvcZhsUGub97Gn/vsg25vesY1u/yj/l26eh3675jt8lVviN0uwJT6ZsabO2m9Iycz57
	g2iDvt+OmyGif5RYijMSDbWYi4oTASQ+6mZcAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9M6sTZX004861


> Hi Eubong,

> one small question inline ...

>> +void arch_trigger_all_cpu_backtrace(bool); +#define
>> arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace

> What is the purpose of this define ? is this maybe a leftover from
> some regex/cleanups ?

Hi John.
Actually, I just follow the same function of sparc architecture.
You can find this in arch/sparc/include/asm/irq_64.h as below

void arch_trigger_all_cpu_backtrace(bool);
#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace

I guess this is used for conditional compile. 
See below.
include/linux/nmi.h
#ifdef arch_trigger_all_cpu_backtrace
static inline bool trigger_all_cpu_backtrace(void)
{
        arch_trigger_all_cpu_backtrace(true);

        return true;
}
static inline bool trigger_allbutself_cpu_backtrace(void)
{
        arch_trigger_all_cpu_backtrace(false);
        return true;
}
#else
static inline bool trigger_all_cpu_backtrace(void)
{
        return false;
}
static inline bool trigger_allbutself_cpu_backtrace(void)
{
        return false;
}
#endif

Thanks. 
> John

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
