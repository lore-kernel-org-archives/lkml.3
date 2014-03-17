Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbaCQBxC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 21:53:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16081 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaCQBw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 21:52:59 -0400
X-AuditID: cbfee690-b7f266d00000287c-b1-53265579aef0
Message-id: <5326557A.9080002@samsung.com>
Date: Mon, 17 Mar 2014 10:52:58 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Tomasz Figa'" <t.figa@samsung.com>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, pawel.moll@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 0/5] ARM: dts: exynos: Add missing dt data to bring
 kernel of Exynos4x12
References: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
 <53204328.7070607@samsung.com> <53211071.4040408@samsung.com>
 <532651E5.6040903@samsung.com> <006201cf4182$77b665f0$672331d0$@samsung.com>
In-reply-to: <006201cf4182$77b665f0$672331d0$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsWyRsSkSLcyVC3Y4PRyZYv5R86xWpx7tZLR
	onfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZ3L7Ma7H0+kUmiwnT17JYvDrYxmKxfsZrFgce
	jzXz1jB6tDT3sHmsXP6FzWPzknqPvi2rGD0+b5Lz2Dg3NIA9issmJTUnsyy1SN8ugStj8YH/
	7AWtTBVfD/E0MB5k7GLk5JAQMJFY1/2HGcIWk7hwbz1bFyMXh5DAUkaJ1pZbQA4HWFHrEX6I
	+HRGiWv/JjNBOK8YJS7fegHWzSugJfH5yxF2kAYWAVWJdRtsQcJsQOH9L26wgdiiAmESK6df
	YYEoF5T4MfkemC0ioCbRs3grI8hMZoEjTBJLHx9gAkkICyRILJixgBli2WVGiVlfHrKDJDgF
	rCSWtM0BW8wsoCOxv3UaG4QtL7F5zVuwBgmBVg6JM8vvsYIkWAQEJL5NPsQC8Y6sxKYDUC9L
	ShxccYNlAqPYLCRHzUIydhaSsQsYmVcxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBMbt6X/P
	JuxgvHfA+hBjMtDKicxSosn5wLjPK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQZG7QX8vJMMNBpmHtiRymDBs4BH6HBI/YKLTqed5150i+o3/hph
	5bLgv5nn5asy26ZcWeu3bmKw29+4LYxOen22LFJvc7XV9qn8+f4loaV98+sLp1cohsz68bZ5
	Yf+MZfuWRPNtcTXa4yRw/4if/3mbk8VbKvqMF0Q1mgasurwsapJs4NqHEk7NSizFGYmGWsxF
	xYkApM2DS/ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQd3KULVgg993pS3mHznHanHu1UpG
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfsyr8XS6xeZLCZMX8ti8epgG4vF+hmvWRx4
	PNbMW8Po0dLcw+axcvkXNo/NS+o9+rasYvT4vEnOY+Pc0AD2qAZGm4zUxJTUIoXUvOT8lMy8
	dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygO5UUyhJzSoFCAYnFxUr6dpgmhIa4
	6VrANEbo+oYEwfUYGaCBhDWMGYsP/GcvaGWq+HqIp4HxIGMXIweHhICJROsR/i5GTiBTTOLC
	vfVsXYxcHEIC0xklrv2bzAThvGKUuHzrBTNIFa+AlsTnL0fYQZpZBFQl1m2wBQmzAYX3v7jB
	BmKLCoRJrJx+hQWiXFDix+R7YLaIgJpEz+KtjCAzmQWOMEksfXyACSQhLJAgsWDGAmaIZZcZ
	JWZ9ecgOkuAUsJJY0jYHbDGzgI7E/tZpbBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9iFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECE4Kz6R2MK5ssDjEKMDBqMTDO0FZLViINbGsuDL3EKME
	B7OSCG+COVCINyWxsiq1KD++qDQntfgQYzIwCCYyS4km5wMTVl5JvKGxiZmRpZG5oYWRsTlp
	wkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MJafqUrITXr6Q7zq4L8TnyRs6+LfcnmwvosU
	e8bz3GPaf9YOTnUXwfenP63eFRV5sHRt3UGvZ0XbA/TmCMSIn+Ne5lrz6JNW4ddTe6t3Xilf
	cYNbVeqp/pld0jZaomoF/3TXzW+ZGt3NJfj5zN2VcpUqf+ZUbTs0+2BLTeXch0phYqGLVwZm
	bVViKc5INNRiLipOBACZAqshTgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

On 03/17/2014 10:44 AM, Kukjin Kim wrote:
> Chanwoo Choi wrote:
>>
>> Dear Kukjin,
>>
>> Ping.
>>
>> Please review this patchset.
>>
> Looks good to me, will apply tonight.

Thanks for your reply.

Best Regards,
Chanwoo Choi
 

