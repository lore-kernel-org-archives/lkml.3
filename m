Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030936Ab3HITp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:45:56 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:59415 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030841Ab3HITpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:45:53 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-7e-520546f06652
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [ 000/102] 3.10.6-stable review
Thread-topic: [ 000/102] 3.10.6-stable review
Thread-index: AQHOlQgAW6aTot4E+kWIZH6aFkzVTw==
Date: Fri, 09 Aug 2013 19:45:51 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61762295@sisaex02sj>
References: <20130809015010.208118575@linuxfoundation.org>
 <B8EFE96D1287C24090BAD9D858E15E61761C23@sisaex02sj>
 <20130809191002.GC10130@kroah.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9hP90PbqxBBp8emlrMWb+GzaJ58Xo2
	i8u75rBZLNj4iNHiUd9bdgdWjxMzfrN47J+7ht3j8ya5AOYoLpuU1JzMstQifbsEroz2lSvY
	CybwV7Svm8XewLiRp4uRk0NCwETi3v9eFghbTOLCvfVsXYxcHEICyxgl/s5exQrh9DJJXJ+8
	Diozn1Fi2q1jTCAtbALqEp9f72AHsUUEjCX6z85iByliFpjJJPH/2ASwImEBHYknB+ZCFelK
	TH59CWgsB5CtJ7F6cjxImEVAVWLi4ucsIGFeAXuJh02BELumMko8XPqUFaSGEei876fWgI1k
	FhCXaG69CXW2gMSSPeeZIWxRiZeP/4GNlxBQlNi+2gqiXEti/c7jUK3aEk/eXQAbySsgKPFj
	8j2WCYxis5BMnYWkZRaSlllIWhYwsqxiFCstTi4oTkpPrTDUK07MLS7NS9dLzs/dxAiJtKod
	jHe+2hxiFOBgVOLhnfCLJUiINbGsuDL3EKMEB7OSCO9rLtYgId6UxMqq1KL8+KLSnNTiQ4xM
	HJxSDYz2PnMKEq5eemlxvq73yYpZbkdaLNO49VadEuy+bv9l2/q5/uGtLVua902NuVLIMUFB
	ktkrR87iednGXNcET1mvAi0ZXxOJ/lUFRVrvL15ZrBUnfC+l6k9hTlNn3czoV4YyfWlTNc+/
	lVug/3/mn/p5R3V/HJih8ufZW/fsrTrar8xVLbm+7lRiKc5INNRiLipOBADnI4GokgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 01:10 PM, Greg Kroah-Hartman wrote:
> On Fri, Aug 09, 2013 at 02:42:24PM +0000, Shuah Khan wrote:
>> On 08/09/2013 07:54 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.10.6 release.
>>> There are 102 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun Aug 11 01:46:31 UTC 2013.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> I don't see the new stable release patches on
>>
>> www.kernel.org/pub/linux/kernel/v3.0/stable-review/
>>
>> Others were able to download last night as I can see from the test
>> responses. Something must have happened. Tried accessing with ftp client
>> as well.
>
> No, the patches never made it there, I think people were testing based
> on the git tree.
>
> kernel.org is now fixed, and the patches should be there within a few
> minutes.
>
> thanks,
>
> greg k-h
>

Greg,

Noticed the following when I applied 3.10.6-rc1

git apply --index < ../stable_tree_project/patch-3.10.6-rc1
<stdin>:1369: space before tab in indent.
  	 * Revision 13 of all triggering devices id in this quirk have
warning: 1 line adds whitespace errors.

Patch applied fine though.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
