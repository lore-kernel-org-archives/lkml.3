Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab3APHMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:12:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53211 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451Ab3APHMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:12:50 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-80-50f652dd2ac7
Message-id: <50F652ED.9020701@samsung.com>
Date: Wed, 16 Jan 2013 16:12:45 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, cwchoi00@gmail.com
Subject: Re: [GIT PULL] extcon for 3.8-rc4
References: <50F5067A.2060104@samsung.com> <20130115113719.GD1748@kroah.com>
 <CAGTfZH2r9TaNEPQ5am-UFwQd9t_qegxfo3MMOwJxvfctid7=-Q@mail.gmail.com>
 <20130115121356.GA2349@kroah.com>
 <CAGTfZH27VUuqqx5b4trMSDDDceWqwHE2wqPZdLbWvvBvbrzpKg@mail.gmail.com>
 <20130115134941.GA25473@kroah.com> <50F620BB.9010602@samsung.com>
 <20130116064640.GB6087@kroah.com>
In-reply-to: <20130116064640.GB6087@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t8zXd27Qd8CDCb+E7W4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ1y48Zin4y1HR/3ANYwNjJ3sXIyeHhICJxIblPUwQtpjEhXvr
	2boYuTiEBJYxSuxfepYZpqhn/wRWiMR0Rom5TTeYIZwuJomuD3vARvEKaEmcnzQDKMHBwSKg
	KrFjWxZImA0ovP/FDTaQsKhAhMSvfg6IakGJH5PvsYDYIgIaEi+P3mIBGcks8J5R4t6lCWAJ
	YaDepVv2Q130jEli16XHbCAJTgE9ic979oDZzAI6Evtbp0HZ8hKb17wFu5pFQEDi2+RDLCCL
	JQRkJTYdALtZQqCZXeLPnhcsEJ9JShxccYNlAqPYLCRHzUIydhaSsQsYmVcxiqYWJBcUJ6Xn
	GuoVJ+YWl+al6yXn525ihESF1A7GlQ0WhxgFOBiVeHi9Cr8GCLEmlhVX5h5ilOBgVhLhXWb/
	LUCINyWxsiq1KD++qDQntfgQow/QtROZpUST84ERm1cSb2hsYGxoaGloZmppaoBDWEmcl/HU
	kwAhgfTEktTs1NSC1CKYcUwcnFINjMbhEy3mPLZfwV1wJ3b3Oe6Oo2r3pr3K2vbEZNHRP3bO
	Mt3V37ctkTyoduPNhymvVqt8qJaJmC5ycfvatSaJqy7Oiv94+UC8wPN9CZJPbh0N9NpQMuVe
	YZmm149ZR0yDtlltn7+11WfWu4vm2/pbja7FffZxvBmofk5LR/LOgsZTWQ9XOqw5bnhIiaU4
	I9FQi7moOBEARznzdLcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jQd27Qd8CDD6fFbS4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGdcuPGYp+MtR0f9wDWMD
	Yyd7FyMnh4SAiUTP/gmsELaYxIV769m6GLk4hASmM0rMbbrBDOF0MUl0fdgD1sEroCVxftIM
	oAQHB4uAqsSObVkgYTag8P4XN9hAwqICERK/+jkgqgUlfky+xwJiiwhoSLw8eosFZCSzwHtG
	iXuXJoAlhIF6l27ZD7X4GZPErkuP2UASnAJ6Ep/37AGzmQV0JPa3ToOy5SU2r3nLPIFRYBaS
	JbOQlM1CUraAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnDMPZPawbiyweIQowAHoxIP
	r1fh1wAh1sSy4srcQ4wSHMxKIrzL7L8FCPGmJFZWpRblxxeV5qQWH2L0AYbARGYp0eR8YDrI
	K4k3NDYxM7I0MjM2MTc2xiGsJM7LeOpJgJBAemJJanZqakFqEcw4Jg5OqQbG0ObXN3M02h4x
	SxfPu3C2/9n3y0UbXyr+b7RWzeu4z3P2X2y+8we2+7/NrHlqlas/zzW7ai311zJxq+WnI3Ws
	5gIsP87lX1n4wyP25/lSVQ/O563rD98ujFL/tyDGxOqeWMSH/KN3zkcI6n062NDPx8ey4+U5
	N9tXDX2/Gm/d419r4cMi8yNQiaU4I9FQi7moOBEAT4L4IOYCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 03:46 PM, Greg KH wrote:
> On Wed, Jan 16, 2013 at 12:38:35PM +0900, Chanwoo Choi wrote:
>>>>  OK, I will resend pull-request to include only bugfixes patch in 3.8.
>>>> After released v3.8-rc7 or 3.8-rc8 kernel, I will send pull-request of extcon
>>>> to include new feature patches of extcon driver in 3.9.
>>>
>>> No, you can send me that pull request now as well, I have two different
>>> branches, one to go to Linus for this release, and one for the next one.
>>> Both of them show up in linux-next.  You should have the same.
>>>
>>> So you can send me two pull requests now, does that make more sense?
>>>
>> I understand and thanks for your comment. I will resend only one pull-request for
>> extcon to include it for -next branch. I don't send separate pull-request
>> for bugfixes patch.
> 
> Why not send a bugfix pull request?  Are none of these for 3.8?  If so,
> fine, but be sure to go through them to determine this.

I think that it isn't critical bug and relevant to extcon core driver.
And The issue is trivial and depend on new feature of max77693 extcon driver.

Thank you,
Chanwoo Choi

