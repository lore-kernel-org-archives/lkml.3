Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaEETmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:42:10 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:21153 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaEETmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:42:08 -0400
X-AuditID: cbfec37b-b7fc26d0000070ab-a2-5367e98eee9c
Message-id: <5367E98B.8070103@samsung.com>
Date: Mon, 05 May 2014 13:42:03 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Tejun Heo <tj@kernel.org>, Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>, olebowle@gmx.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 1/4] drivers/base: add managed token devres interfaces
References: <cover.1398797954.git.shuah.kh@samsung.com>
 <6cb20ce23f540c883e60e6ce71302042b034c4aa.1398797955.git.shuah.kh@samsung.com>
 <20140501145337.GC31611@htj.dyndns.org> <5367E39E.7090401@samsung.com>
 <20140505192633.GQ11231@htj.dyndns.org>
 <CAGoCfiwoFipx79tx6Jkgx5nfU_K9qXdfGe25kzrNb6Jwka0H7A@mail.gmail.com>
 <20140505193616.GR11231@htj.dyndns.org>
In-reply-to: <20140505193616.GR11231@htj.dyndns.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.11]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t9hP92+l+nBBs+XWFvc2r2axaJ58Xo2
	i8u75rBZ9GzYymox8W69xa/lRxkd2Dzu3l/I5LFpVSebx9xjvYwe++euYff4vEkugDWKyyYl
	NSezLLVI3y6BK+Pb8b+sBf/YK87Nm8PWwLiWrYuRk0NCwETiWvcaZghbTOLCvfVAcS4OIYFl
	jBJrn99mhHB6mSQO7uxiAqkSEtjEKPFxvTeIzSugJXH26HZGEJtFQFXi0ZNfrCA2m4C6xOfX
	O9gh6uUkmpasBtrAwSEqECHx+IIQRKugxI/J91hAbBEBP4kdbw+xgOxiFmhmkvjW2sUKUi8s
	4CXx/1swxJg3TBIz2y1AbE6go09/2gp2DrOAtcTKSdsYIWx5ic1r3jJD1CtL/Ll8iglkjISA
	osSv/+4TGEVmIdk8C0n3LCTdCxiZVzGKlRYnFxQnpadWGOkVJ+YWl+al6yXn525ihERO9Q7G
	u19tDjEKcDAq8fAqrEkPFmJNLCuuzD3EKMHBrCTC2/gYKMSbklhZlVqUH19UmpNafIiRiYNT
	qoExfLPxT8X7c1/lx2seEH/4bfnlJavM1c5JK9bk6bJpTzmRejtBa01Oefb62rVH34eXS5/i
	3Pqspu2maexG7Vm5Huav+FRu2p2Yk9Y6z+VFIePpvE0ifFd+3vKqlFj4oUfw6qvz81Y/PXns
	XvxCqWWhhsIv89etKL066/VLvv6FOW6fDa69PCSlpcRSnJFoqMVcVJwIAM567uZ6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 01:36 PM, Tejun Heo wrote:
> On Mon, May 05, 2014 at 03:30:34PM -0400, Devin Heitmueller wrote:
>> On Mon, May 5, 2014 at 3:26 PM, Tejun Heo <tj@kernel.org> wrote:
>>> As such, please consider the patches nacked and try to find someone
>>> who can shepherd the code.  Mauro, can you help out here?
>>
>> We actually discussed this proposal at length at the media summit last
>> week.  The patches are being pulled pending further internal review
>
> "being pulled into a tree" or "being pulled for more work"?
>
>> and after Shuah has exercised some other use cases.

As I said in my response:

"This new device I am testing with now presents all the use-cases that
need addressing. So I am hoping to refine the approach and make course
corrections as needed with this device."

More work is needed to address the use-cases.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
