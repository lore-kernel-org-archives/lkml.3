Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762AbaFJBcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:32:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30385 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934646AbaFJBcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:32:19 -0400
X-AuditID: cbfee68f-b7fef6d000003970-94-53966020b563
Message-id: <53966020.9020600@samsung.com>
Date: Tue, 10 Jun 2014 10:32:16 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCHv3 2/3] regulator: s2mps11: Add support S2MPU02 regulator
 device
References: <1402294548-10380-1-git-send-email-cw00.choi@samsung.com>
 <1402294548-10380-3-git-send-email-cw00.choi@samsung.com>
 <20140609195543.GK5099@sirena.org.uk>
In-reply-to: <20140609195543.GK5099@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWyRsSkWFchYVqwwexuM4upD5+wWXSefcJs
	8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBa3G1ewWZzuZrW4uOILkwOXx85Zd9k9Nq3qZPO4
	c20Pm8e8k4EefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlbGq8wtzwTXWiqk/jzE1MG5i6WLk
	5JAQMJHoXtnJDmGLSVy4t56ti5GLQ0hgKaPEvwMrmGGKelreQSWmM0p8mHgcrENI4DWjxL47
	PCA2r4CWxJoDu9lAbBYBVYl326eB2WxA8f0vboDZogJhEiunX2GBqBeU+DH5HpgtIqAscfX7
	XhaQBcwCjxklZv1dxAqSEBYIlZh8eTIjxOaVjBInuraBJTgFjCT2fj7OCGIzC+hI7G+F2MYs
	IC+xec1bZpAGCYGX7BLHTj5mhjhJQOLb5ENAKziAErISmw5AvSYpcXDFDZYJjGKzkBw1C8nY
	WUjGLmBkXsUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGJ2n/z3r38F494D1IcZkoJUTmaVE
	k/OB0Z1XEm9obGZkYWpiamxkbmlGmrCSOO/9h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODil
	Ghg5utkaxNSui18pvbPGm+E6++WF3cd3zrdW9uAumn1bPmDanBRZlhjlqDV9Ngd/pJYsVn9a
	F/Rkqdq3Ow5VxjsOR8RZHMtyV78R+Nj2Q9Izn31n26dbr3NfVN8rtW694YxZcgbSpvH5rDN8
	lyV3/tix9EnhK4H7Ky/3BmfcbJBbPc84a9aCw65KLMUZiYZazEXFiQDB6fJj5AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQV2FhGnBBn++6llMffiEzaLz7BNm
	i9cvDC3ONr1ht7j/9SijxbcrHUwWl3fNYbO43biCzeJ0N6vFxRVfmBy4PHbOusvusWlVJ5vH
	nWt72DzmnQz06NuyitHj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	NYwZqzq/MBdcY62Y+vMYUwPjJpYuRk4OCQETiZ6Wd2wQtpjEhXvrgWwuDiGB6YwSHyYeZwdJ
	CAm8ZpTYd4cHxOYV0JJYc2A3WAOLgKrEu+3TwGw2oPj+FzfAbFGBMImV06+wQNQLSvyYfA/M
	FhFQlrj6fS8LyAJmgceMErP+LmIFSQgLhEpMvjyZEWLzSkaJE13bwBKcAkYSez8fZwSxmQV0
	JPa3QmxjFpCX2LzmLfMERoFZSJbMQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5
	mxjBsf9MegfjqgaLQ4wCHIxKPLwWB6YGC7EmlhVX5h5ilOBgVhLhZf0IFOJNSaysSi3Kjy8q
	zUktPsSYDAyDicxSosn5wLSUVxJvaGxiZmRpZG5oYWRsTpqwkjjvwVbrQCGB9MSS1OzU1ILU
	IpgtTBycUg2MnJIfq6Ra/Hf+dfpsl8m9anvr7An7O9ZK1M/9Z2Am7bgjf3/4c8lPRZekdHZ3
	v390ZoXItfV/y786RSYHSswJnV9/UfZmn/VThjubZZfJFy21yjOe4+B+LULB8qzm27szi4Iu
	9okbySS0xJ2fuqC4JcP59K4zxxdadnO1KRdd/Vio+2q/cL+MEktxRqKhFnNRcSIAtrT8pEED	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 06/10/2014 04:55 AM, Mark Brown wrote:
> On Mon, Jun 09, 2014 at 03:15:47PM +0900, Chanwoo Choi wrote:
>> This patch add S2MPU02 regulator device to existing S2MPS11 device driver
>> because of little difference between S2MPS1x and S2MPU02. The S2MPU02
>> regulator device includes LDO[1-28] and BUCK[1-7].
> 
> Acked-by: Mark Brown <broonie@linaro.org>
> 
> but a few nits:
> 
>> +	case S2MPS14X:
>> +		switch (rdev_id) {
>> +		case S2MPS14_LDO3:
>> +			return 0;
>> +		};
> 
> Extra ; here, and a missing default case here and in the rest of the
> switches.  The default cases have no effect but are better style.
> 

OK, I'll add 'default' case statement.

Best Regards,
Chanwoo Choi
