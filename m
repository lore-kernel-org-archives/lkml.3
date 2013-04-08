Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934851Ab3DHDwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 23:52:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27198 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934777Ab3DHDwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 23:52:07 -0400
X-AuditID: cbfee68e-b7f946d000001e37-f6-51623ee54844
Message-id: <51623EEA.80401@samsung.com>
Date: Mon, 08 Apr 2013 12:52:10 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] extcon fixes for 3.9-rc6
References: <51622526.8000302@samsung.com> <20130408023621.GA5894@kroah.com>
In-reply-to: <20130408023621.GA5894@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t8zXd2ndkmBBhvnSlo0L17PZnG26Q27
	xeVdc9gsbjeuYHNg8dg/dw27R9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGVsvHCLvaCJu+LT
	v0nsDYw/OLoYOTkkBEwkDj/tZ4GwxSQu3FvP1sXIxSEksIxR4tLKL4wwRdMfPmOHSExnlDh4
	agszhPOCUWLq3U4mkCpeAQ2JS/vWsYPYLAKqErtaH4LF2QS0JPa/uMEGYosKhEmsnH6FBaJe
	UOLH5HtgtghQ78ujt8BsZoEyicWtc8B6hQUMJJ4v/woWFxLwkdh//RuYzSmgJ/Fh0U52iHod
	if2t09ggbHmJzWvegh0nIbCMXWLr3OPMEAcJSHybfAiomQMoISux6QAzxGeSEgdX3GCZwCg2
	C8lJs5CMnYVk7AJG5lWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIXHUt4Px5gHrQ4zJQCsn
	MkuJJucD4zCvJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYwh2YXM8oUxD6bxCffIzWicuXupxYFy4RNs04oFzO1e7lAMzGf6pNO6WyX88t4ssVcn
	RE1XzVz9RkC33PyTYefF5St1eES+K6zhZ5wYVOJm5bFpI5vq9uXyvx0cGx9+6pGMUnua2iEx
	j+/vHGlWreq/mrsYwwPfNLPPSpH55/i1w8v22sEfjEosxRmJhlrMRcWJAJMnZJi5AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xoO5Tu6RAg5uHRCyaF69nszjb9Ibd
	4vKuOWwWtxtXsDmweOyfu4bdo2/LKkaPz5vkApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DWKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1
	DQmC6zEyQAMJ6xgzNl64xV7QxF3x6d8k9gbGHxxdjJwcEgImEtMfPmOHsMUkLtxbz9bFyMUh
	JDCdUeLgqS3MEM4LRompdzuZQKp4BTQkLu1bB9bBIqAqsav1IVicTUBLYv+LG2wgtqhAmMTK
	6VdYIOoFJX5MvgdmiwD1vjx6C8xmFiiTWNw6B6xXWMBA4vnyr2BxIQEfif3Xv4HZnAJ6Eh8W
	7WSHqNeR2N86jQ3ClpfYvOYt8wRGgVlIVsxCUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGMFR+kx6B+OqBotDjAIcjEo8vAe+JgYKsSaWFVfmHmKU4GBWEuENVE4KFOJNSays
	Si3Kjy8qzUktPsSYDAyBicxSosn5wASSVxJvaGxiZmRpZGZsYm5sTJqwkjjvwVbrQCGB9MSS
	1OzU1ILUIpgtTBycUg2MCydNen6v9YFk1weWvR6h1w6Vi+xjWbTjza2mfyfEbMVirfor1lVp
	XmNiqBJv3ZarWZm11/pZSvqc92wSc7b8Yo/0iVV7+edb5vS9W5ZdZfmUkud/NGOC7b+czL/d
	c+YH6SxdrSvtP7cwc/+tT5OlvgYsnvP+XJTizMzthrp8d2rTN/P+2p0yU4mlOCPRUIu5qDgR
	AHiE4LEWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 11:36 AM, Greg KH wrote:
> On Mon, Apr 08, 2013 at 11:02:14AM +0900, Chanwoo Choi wrote:
>> Hi Greg,
>>
>> This is extcon fixes for 3.9-rc6
>> Please pull extcon with following updates.
>>
>> Best Regards and thanks,
>> Chanwoo Choi
>>
>> The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:
>>
>>   Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-3.9-rc6
>>
>> for you to fetch changes up to 2fbeb4347e02078828510e5fe43ab4bea21b20d1:
>>
>>   extcon: max8997: Fix return value (2013-04-08 09:13:18 +0900)
>>
>> ----------------------------------------------------------------
>> This is small fixes for extcon driver.
>>
>> MAX77693 extcon driver
>> - Add 'static' keryword to internal data structure
>> - Fix return value using 'ret' instead of hardcoding
>>
>> MAX8997 extcon driver
>> - Use dev_err() instead of pr_err()
>> - Fix return value using 'ret' instead of hardcoding
> None of these should go into 3.9-final, they are all trivial cleanups.
> Only major bug fixes or regressions should be sent right now for 3.9,
> sorry.
>
> I will be glad to pull these into my -next branch for 3.10 if you want.
>
> greg k-h
>
OK, I agree completely with your opinion. Thanks.

Best Regards,
Chanwoo Choi
