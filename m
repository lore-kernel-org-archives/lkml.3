Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbaGPKWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:22:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38570 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbaGPKW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:22:29 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-f6-53c652630761
Sun-Java-System-SMTP-Warning: Lines longer than SMTP allows found and wrapped.
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bean Huo'" <beanhuo@outlook.com>, dwmw2@infradead.org,
        computersforpeace@gmail.com
Cc: paul.gortmaker@windriver.com, artem.bityutskiy@linux.intel.com,
        b32955@freescale.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, christian.riesch@omicron.at,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <BLU185-W10713E955F9530C4D53490A6F70@phx.gbl>
 <BLU185-W62B0858FCD7D3A71127B41A6F70@phx.gbl>
 <002201cfa0ca$be634b10$3b29e130$%han@samsung.com>
 <BLU185-W44C89261B8307EBFCC2EC0A6F70@phx.gbl>
In-reply-to: <BLU185-W44C89261B8307EBFCC2EC0A6F70@phx.gbl>
Subject: Re: [PATCH v5] mtd:nor:timeout:fix do_write_buffer() timeout error
Date: Wed, 16 Jul 2014 19:22:27 +0900
Message-id: <003f01cfa0df$d79d5fc0$86d81f40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+g0sVBJ6QCPIuqSuKtF9eRmqxtoQACyYSw
Content-language: ko
x-cr-hashedpuzzle: JfWN O4wh YT4N kW9v k+kZ nN6R tJNc 0ndj 1k0o 5KLx +hlz
 ABWQLA== ACYUSw== AFps6g== AFrlSA==
 AIgw3A==;10;YQByAHQAZQBtAC4AYgBpAHQAeQB1AHQAcwBrAGkAeQBAAGwAaQBuAHUAeAAuAGkAbgB0AGUAbAAuAGMAbwBtADsAYgAzADIAOQA1ADUAQABmAHIAZQBlAHMAYwBhAGwAZQAuAGMAbwBtADsAYgBlAGEAbgBoAHUAbwBAAG8AdQB0AGwAbwBvAGsALgBjAG8AbQA7AGMAaAByAGkAcwB0AGkAYQBuAC4AcgBpAGUAcwBjAGgAQABvAG0AaQBjAHIAbwBuAC4AYQB0ADsAYwBvAG0AcAB1AHQAZQByAHMAZgBvAHIAcABlAGEAYwBlAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBkAHcAbQB3ADIAQABpAG4AZgByAGEAZABlAGEAZAAuAG8AcgBnADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBtAHQAZABAAGwAaQBzAHQAcwAuAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBwAGEAdQBsAC4AZwBvAHIAdABtAGEAawBlAHIAQAB3AGkAbgBkAHIAaQB2AGUAcgAuAGMAbwBtAA==;Sosha1_v1;7;{B2F6DB05-0FD8-4635-9E5F-7086008EBB75};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 16 Jul 2014 10:22:11
 GMT;UgBlADoAIABbAFAAQQBUAEMASAAgAHYANQBdACAAbQB0AGQAOgBuAG8AcgA6AHQAaQBtAGUAbw
	B1AHQAOgBmAGkAeAAgAGQAbwBfAHcAcgBpAHQAZQBfAGIAdQBmAGYAZQByACgAKQAgAHQAaQBtAGUAbwB1AHQAIABlAHIAcgBvAHIA
x-cr-puzzleid: {B2F6DB05-0FD8-4635-9E5F-7086008EBB75}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t8zfd3koGPBBq3r5SzePH7GbHFhlozF
	gwcLmC2uN29ktzhyYS2zxcSVk5ktLi+8xGpxedccNovdTcvYLa7tPc7swOXx73A/k8fOWXfZ
	PTav0PKYdzLQY/OSeo/VE5axeWx+/YLZo2/LKkaPz5vkPNZv2coUwBXFZZOSmpNZllqkb5fA
	lXG2YxJrQbNYRcfy+0wNjMsFuxg5OSQETCRmPf3LAmGLSVy4t54NxBYSWMYosfdhEEzNjJ4p
	7F2MXEDx6YwSD29fZIJwfjNKfN/zmxmkSljAT6JpziQwm01ATeLLl8PsILaIQITE8TMLwRqY
	Be4wSizYsp4Vovsso8TTC28ZQao4BawkmtadZ4GY5C3R3fMGzGYRUJWYePAr0CQODl4BW4mO
	1gyQMK+AoMSPyffASpgFdCR6v39jhrC1JZ68u8AKUi4hoC7x6K8uxA1GEm9/zmaEKBGR2Pfi
	HSPICRICbzgkbr5vY4J401Ri3/E5TBCJMxwSuxtuMkHcICDxbfIhFoihshKbDjBD1EtKHFxx
	g2UCo/QsJCfNQnLSLCQnzUKyewEjyypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkITSu4Px
	9gHrQ4zJQOsnMkuJJucDE1JeSbyhsZmRhamJqbGRuaUZacJK4rxJD5OChATSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTBufHG+InKiJp93VWGM2rtbMjdn745g2nSJuf9I2JpbPkHpu0NfS/D3
	ac127VijMouL1fd9weziqq8iD75VNqVIJWlcqjO895S3L0ClM7Bie7tWmHB2/N/2OpZZN0KP
	LlBwcd3RyD3zaFj3gQtn+R5Z6Qg95+a8cTUh8IHD6j+Rf3wq9q+d8FCJpTgj0VCLuag4EQBL
	g0JhPgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jQd3koGPBBku6JC3ePH7GbHFhlozF
	gwcLmC2uN29ktzhyYS2zxcSVk5ktLi+8xGpxedccNovdTcvYLa7tPc7swOXx73A/k8fOWXfZ
	PTav0PKYdzLQY/OSeo/VE5axeWx+/YLZo2/LKkaPz5vkPNZv2coUwBXVwGiTkZqYklqkkJqX
	nJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SrkkJZYk4pUCggsbhYSd8O
	04TQEDddC5jGCF3fkCC4HiMDNJCwjjHjbMck1oJmsYqO5feZGhiXC3YxcnJICJhIzOiZwg5h
	i0lcuLeerYuRi0NIYDqjxMPbF5kgnN+MEt/3/GYGqRIW8JNomjMJzGYTUJP48uUwWLeIQITE
	8TMLwRqYBe4wSizYsp4Vovsso8TTC28ZQao4BawkmtadZ4GY5C3R3fMGzGYRUJWYePAr0CQO
	Dl4BW4mO1gyQMK+AoMSPyffASpgFdCR6v39jhrC1JZ68u8AKUi4hoC7x6K8uxA1GEm9/zmaE
	KBGR2PfiHSPICRICbzgkbr5vY4J401Ri3/E5TBMYRWchWTELyYpZSFbMQjJrASPLKkbR1ILk
	guKk9FxDveLE3OLSvHS95PzcTYzghPVMagfjygaLQ4wCHIxKPLwbQo4GC7EmlhVX5h5ilOBg
	VhLhdfA/FizEm5JYWZValB9fVJqTWnyI0RQYABOZpUST84HJNK8k3tDYxMzI0sjMwsjE3FxJ
	nPdAq3WgkEB6YklqdmpqQWoRTB8TB6dUA6PS6ijuy2ILtyt7WM61OjF71eQshvDQq3MrlrzY
	POHlMy7tK15y+evbj1Zo2iz9wvk57UKJu9uCOaIecstiz72uVnj3YgfLrtKXM94fbbYvesOo
	EmKfbubvIq/Y+GqK97Oj6+45CCR1hVq73sz8p+8oEjjDdJaw78W+HtEKj4/B241/f7OclKrE
	UpyRaKjFXFScCAA1m56vbgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2014 5:49 PM, Bean Huo wrote:
> 
> >> + if (cfi->cfiq->BufWriteTimeoutTyp &&
> >> + cfi->cfiq->BufWriteTimeoutMax){
> >> + cfi->chips[i].buffer_write_time_max =
> >> + 1<<(cfi->cfiq->BufWriteTimeoutTyp +
> >> + cfi->cfiq->BufWriteTimeoutMax);
> >> + } else {
> >> + cfi->chips[i].buffer_write_time_max = 0;
> >> + }
> >
> > Please keep the coding style as below.
> >
> > if ( ) {
> > ...
> > } else {
> > ...
> > }
> >
> 
> If I keep coding style as above.this will be beyond the requirements of one line length.
> I also saw othter files use the same code style as mine.please see:cfi_cmdset_0001.c
> 
> if (cfi->cfiq->WordWriteTimeoutTyp &&
>      cfi->cfiq->WordWriteTimeoutMax)
>         cfi->chips[i].word_write_time_max =
> 		1<<(cfi->cfiq->WordWriteTimeoutTyp +
> 		      cfi->cfiq->WordWriteTimeoutMax);
> else
>       cfi->chips[i].word_write_time_max = 50000 * 8;

I don't want to mention about braces.
However, I said that you should keep the indentation.

Your original patch

+		if (cfi->cfiq->BufWriteTimeoutTyp &&
+			cfi->cfiq->BufWriteTimeoutMax){
+			cfi->chips[i].buffer_write_time_max =
+				1<<(cfi->cfiq->BufWriteTimeoutTyp +
+					cfi->cfiq->BufWriteTimeoutMax);
+			} else {
+				cfi->chips[i].buffer_write_time_max = 0;
+				}
+		cfi->chips[i].buffer_write_time_max =
+			((cfi->chips[i].buffer_write_time_max>= 2000)
+			 ? cfi->chips[i].buffer_write_time_max : 2000);

My suggestion is as follows: 

+		if (cfi->cfiq->BufWriteTimeoutTyp &&
+			cfi->cfiq->BufWriteTimeoutMax){
+			cfi->chips[i].buffer_write_time_max =
+				1<<(cfi->cfiq->BufWriteTimeoutTyp +
+					cfi->cfiq->BufWriteTimeoutMax);
+		} else {
+			cfi->chips[i].buffer_write_time_max = 0;
+		}
+		cfi->chips[i].buffer_write_time_max =
+			((cfi->chips[i].buffer_write_time_max>= 2000)
+			 ? cfi->chips[i].buffer_write_time_max : 2000);

Braces? I have no idea. Actually, I prefer to use braces for the
readability. However, according to the Document/CodingStyle, 
these braces are unnecessary.

However, one thing is clear; 'if' and 'else' should use the same
indentation level as below.

1. 
	if(){
		...
	} else {
		...
	}

2.
		if(){
			...
		} else {
			...
		}

3.

			if(){
				...
			} else {
				...
			}

Best regards,
Jingoo Han

> 
> Note: beacuse I cann't send mail by git in office,I send this patch by web mail client.So,
> there still a error stype in this patch(web mail client will remove some spaces),that is one space
> required before that '>='.I will send again this patch at home.
> For your coding style advice, I will take into account,but i don't know if can put one line.
> 	 	   		  =

