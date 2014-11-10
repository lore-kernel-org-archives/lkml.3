Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaKJFlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:41:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:34596 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaKJFlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:41:08 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-87-54604ff1fe12
Message-id: <54604FE9.8070902@samsung.com>
Date: Mon, 10 Nov 2014 14:40:57 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 5/5] Documentation: Add documentation for rt5033
 multifunction device
References: <1415328727-16245-1-git-send-email-beomho.seo@samsung.com>
 <1415328727-16245-6-git-send-email-beomho.seo@samsung.com>
 <20141107103440.GD8509@sirena.org.uk>
In-reply-to: <20141107103440.GD8509@sirena.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSrPvJPyHE4G0fi8XUh0/YLOYfOcdq
	cXnXHDaLz71HGB1YPDat6mTz+LxJLoApissmJTUnsyy1SN8ugSvj2uotzAXfWCt6Vhg0MJ5j
	6WLk5JAQMJE4feUfE4QtJnHh3nq2LkYuDiGBpYwSU7vWsMEUzVj3kxkiMZ1RYsnU2awQzmtG
	iSt/pjCCVPEKaEls27IRbCyLgKrEn+l3mEFsNgFNifdTroDFRQUiJK6smQNVLyjxY/I9sLiI
	gLLE1e97wWxmoJo9284BncTBISwQLbFoVSnErtWMEnPOHWcFiXMKGEksv8cIYjIL6Encv6gF
	0SkvsXnNW7A7JQSms0vcvPuNGeIcAYlvkw+xgNRLCMhKbDrADPGXpMTBFTdYJjCKzUJy0CyE
	qbOQTF3AyLyKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIzBqTv97NmEH470D1ocYBTgYlXh4
	Hd7GhwixJpYVV+YeYjQFOmIis5Rocj4wNvNK4g2NzYwsTE1MjY3MLc2UxHlfS/0MFhJITyxJ
	zU5NLUgtii8qzUktPsTIxMEp1cBofKVEfsv9zQvzzat2unX43T86/6CGY/ccIxPm1p4K/TmM
	u2IZfnvxSLJl/5fNdErxsOeTnWfeeFhcbfKKw+x7I7OT2Hc+9z65enuxyeO6M1HTs0oEoxj1
	lsi9kguqCWuoOP5XT/7TuzibjC2FOoxOjFz274oP873Pt9/aOOm96DPnroL8Y0osxRmJhlrM
	RcWJAL6Q/+SVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t9jQd2P/gkhBudOWVpMffiEzWL+kXOs
	Fpd3zWGz+Nx7hNGBxWPTqk42j8+b5AKYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCWsYM66t3sJc8I21omeFQQPjOZYuRk4OCQETiRnrfjJD2GISF+6tZ+ti5OIQEpjOKLFk
	6mxWCOc1o8SVP1MYQap4BbQktm3ZCNbNIqAq8Wf6HbBuNgFNifdTroDFRQUiJK6smQNVLyjx
	Y/I9sLiIgLLE1e97wWxmoJo9284xdTFycAgLREssWlUKsWs1o8Scc8dZQeKcAkYSy+8xgpjM
	AnoS9y9qQXTKS2xe85Z5AqPALCQLZiFUzUJStYCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcEw+k9rBuLLB4hCjAAejEg+vw9v4ECHWxLLiytxDjBIczEoivLX/gUK8KYmVValF+fFF
	pTmpxYcYTYHen8gsJZqcD0wXeSXxhsYmZkaWRuaGFkbG5krivAdarQOFBNITS1KzU1MLUotg
	+pg4OKUaGGVzooPeuHz7bvG6S7Yqo2Oa7tVdl7690xe+t9rxkUfLghkXzG/bcrxlr9SeekBl
	I8cE7v15mxf8V1DI7RT5Um5T/XzWQe61Pe5H5py4Kzcja69MEfM1VqFl6Y/Uwl/0/vHMeF96
	OITf1ED0scGvJf1xKTZXXhu4rCtNls+Ye4lzWcgplRVcS5VYijMSDbWYi4oTATQZO/ffAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your advice.
I'll fix them and send v2 patch soon.

On 11/07/2014 07:34 PM, Mark Brown wrote:
> On Fri, Nov 07, 2014 at 11:52:07AM +0900, Beomho Seo wrote:
> 
>> +Required properties:
>> +- compatible = Must be "richtek,rt5033-regulator"
>> +
>> +	regulators {
>> +		compatible = "richtek,rt5033-regulator";
> 
> There should be no need for this extra compatible, it's not adding
> anything we didn't know from the fact that it's part of the MFD.
> 
>> +		regulator-name {
>> +			regulator-name = LDO/BUCK
>> +			standard regulator constraints...
>> +		};
> 
> Better to just say something like "regulator subnodes called X, Y and Z"
> described using the standard regulator binding in...
> 

Best regards,
Beomho Seo
