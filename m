Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaJGJg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:36:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43762 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaJGJgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:36:54 -0400
X-AuditID: cbfee68f-f791c6d000004834-ad-5433b42c405e
Message-id: <5433B42C.2090902@samsung.com>
Date: Tue, 07 Oct 2014 18:36:44 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Build regressions/improvements in v3.17
References: <1412620095-593-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdWCTfJWWdeHSh3jOJx+9CCGfsONrR6X4vew4j5cULUpzg@mail.gmail.com>
In-reply-to: <CAMuHMdWCTfJWWdeHSh3jOJx+9CCGfsONrR6X4vew4j5cULUpzg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSpKuzxTjEYP1bY4tnt/YyWVzeNYfN
	4nbjCjYHZo9DhzsYPfq2rGL0+LxJLoA5issmJTUnsyy1SN8ugStj8tztTAVdohXH1i5kbGC8
	JtjFyMkhIWAicb3nCRuELSZx4d56IJuLQ0hgKaPE8tcH2GGKfp67DlYkJLCIUWL6FS+IoteM
	Ev3rprKCJHgFtCS+L9wC1MDBwSKgKnHgbw5ImA0ovP/FDbBeUYEwiZXTr7BAlAtK/Jh8jwWk
	XERAV2LOTyaQMLNAjsTnDQ+ZQWxhoLUbn3awQqzqZJS48mc6WC+nQLDErb2roRrUJSbNW8QM
	YctLbF7zlhmkQUJgOrvEz9uHwBpYBAQkvk0+BLZMQkBWYtMBZoi/JCUOrrjBMoFRbBaSk2Yh
	GTsLydgFjMyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MQIj5/S/Z/07GO8esD7EKMDBqMTD
	u0LLOESINbGsuDL3EKMp0BUTmaVEk/OB8ZlXEm9obGZkYWpiamxkbmmmJM67UOpnsJBAemJJ
	anZqakFqUXxRaU5q8SFGJg5OqQbGJerZT92DtBys96u4RPud+6+idWXidEOTn4Ji545MEgxP
	CLqYPSHzhp1NyZJJ/QvzU7dP2ch0q+nqql32zmJ17S8msK8vDXUUTznysWbayhtX88NMVh24
	6DSl4L1+EdOEmfMiJv0vCZ0inPeep9Nb7NaO/b9YDoivXFNn4d4dkRlZwrr689EFSizFGYmG
	WsxFxYkA1DQkcpcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t9jAV2dLcYhBtvn6Vg8u7WXyeLyrjls
	FrcbV7A5MHscOtzB6NG3ZRWjx+dNcgHMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhDWMGZPnbmcq6BKtOLZ2IWMD4zXBLkZODgkBE4mf566zQdhiEhfurQezhQQWMUpMv+LV
	xcgFZL9mlOhfN5UVJMEroCXxfeEW9i5GDg4WAVWJA39zQMJsQOH9L26A9YoKhEmsnH6FBaJc
	UOLH5HssIOUiAroSc34ygYSZBXIkPm94yAxiCwOdsPFpByvEqk5GiSt/poP1cgoES9zauxqq
	QV1i0rxFzBC2vMTmNW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vO
	z93ECI7LZ1I7GFc2WBxiFOBgVOLhXaFlHCLEmlhWXJl7iFGCg1lJhDdjPVCINyWxsiq1KD++
	qDQntfgQoykwACYyS4km5wNTRl5JvKGxiZmRpZG5oYWRsbmSOO+BVutAIYH0xJLU7NTUgtQi
	mD4mDk6pBsalbV9P7rnOxGNSFye8g3dmQfzbRWWvRKRXPb8wu4dNwiz7VIuvZrrhv2hfpRMG
	/RMKPZLO96WK694qbDxu1+KTapxq6fxqk/n0D4bvvCTXPpi7UjXo5taa6K1xTKmuCy1DS3OS
	RU4mOxrv/VHX/yZkXyLLy/oVuR3Xxbfr6heuTErw2LLhgRJLcUaioRZzUXEiAIbpdwXhAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Geert,

On 10/07/2014 03:39 AM, Geert Uytterhoeven wrote:
> On Mon, Oct 6, 2014 at 8:28 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> JFYI, when comparing v3.17[1]  to v3.17-rc7[3], the summaries are:
>>   - build errors: +12/-6
> 
>   + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
> implicit declaration of function 'i2c_check_functionality'
> [-Werror=implicit-function-declaration]:  => 117:2
>   + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
> implicit declaration of function 'i2c_master_send'
> [-Werror=implicit-function-declaration]:  => 96:2
>   + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
> implicit declaration of function 'i2c_smbus_read_byte_data'
> [-Werror=implicit-function-declaration]:  => 28:2
>   + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
> implicit declaration of function 'i2c_smbus_read_word_data'
> [-Werror=implicit-function-declaration]:  => 64:2
>   + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
> implicit declaration of function 'i2c_smbus_write_byte_data'
> [-Werror=implicit-function-declaration]:  => 46:2
>   + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
> implicit declaration of function 'i2c_smbus_write_word_data'
> [-Werror=implicit-function-declaration]:  => 82:2
>   + /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error:
> implicit declaration of function 'i2c_transfer'
> [-Werror=implicit-function-declaration]:  => 130:2
>   + /scratch/kisskb/src/drivers/extcon/extcon-sm5502.c: error:
> implicit declaration of function 'i2c_add_driver'
> [-Werror=implicit-function-declaration]:  => 718:2
> 
> x86_64-randconfig
> 
> Fix available, even promised by the maintainer to be in 3.17-rc2:

I'm so sorry, I didn't send this patch to fix this issue in 3.17-rc2.

This issue will be fixed on 3.18-rc1. This patch was merged and you can check it as following:
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=0746d5d31f61721bf3e4ab84d75fac08d03e2a9a

Best Regards,
Chanwoo Choi

> 
> https://lkml.org/lkml/2014/8/20/874
> 
>> [1] http://kisskb.ellerman.id.au/kisskb/head/7938/ (118 out of 119 configs)
>> [3] http://kisskb.ellerman.id.au/kisskb/head/7921/ (all 119 configs)
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

