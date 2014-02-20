Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaBTNkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:40:40 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:47735 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaBTNki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:40:38 -0500
X-AuditID: cbfec37a-b7fc06d00000555a-7e-530605d4dc59
Message-id: <530605D2.1080608@samsung.com>
Date: Thu, 20 Feb 2014 06:40:34 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.13 00/40] 3.13.4-stable review
References: <20140218224433.337299968@linuxfoundation.org>
 <53054956.4010602@samsung.com> <20140220003639.GF2669@sirena.org.uk>
 <5305584D.9030106@samsung.com> <20140220023437.GS2669@sirena.org.uk>
In-reply-to: <20140220023437.GS2669@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.4]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9hP90rrGzBBv9PmlrMWb+GzWLqwyds
	Fs2L17NZXN41h83i608HiwUbHzFaPOp7y+7A7rFz1l12j02rOtk8Tsz4zeKxf+4ado/Pm+QC
	WKO4bFJSczLLUov07RK4MiZ/mspU8Ia54ufLw6wNjP+Zuhg5OSQETCTuvTrICGGLSVy4t56t
	i5GLQ0hgGaPE9U3nmUESQgK9TBKXvgdCJDYwSmz7u5YVJMEroCUxoa0BbBKLgKrEkSsPwSax
	CahLfH69gx2iWU6iaclqsEGiAhESr85OZIHoFZT4MfkemC0ioCxx9fteFpAFzAI/GSV+nXkO
	1iAMdN6dn49YIAadYJSYsy8NxOYUMJI4tPEvG4jNLGAtsXLSNkYIW15i85q3UFcrS/y5fArq
	TQWJFTfesExgFJmFZPcsJO2zkLQvYGRexShWWpxcUJyUnlphqFecmFtcmpeul5yfu4kREklV
	OxjvfLU5xCjAwajEwxtxnSVYiDWxrLgy9xCjBAezkgjvlg+swUK8KYmVValF+fFFpTmpxYcY
	mTg4pRoYhV39TjoLpcoobzqjfFwvxpB5e4yCRn+7mZVdatKKpbnsjGu1libe7Z9es3j7j+9V
	WVdneWpmJvjdd2o09GFqW61w36ShM/tH7Rsztc0s/zk+r69ZcziNNS9uXe4koSNPsrrTso3Z
	tESdJodoLnth1Ls9Yu835Y/rZp2bsKz9TO8bozv7j65RYinOSDTUYi4qTgQAxJ5HFoICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 07:34 PM, Mark Brown wrote:
> On Wed, Feb 19, 2014 at 06:20:13PM -0700, Shuah Khan wrote:
>
>> Right. I think this message should be a warning instead of an error.
>> Error is too alarming, unless there is a good reason for it to be an
>> error.
>
> Patches welcome...
>

ok I will send one soon then :)

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
