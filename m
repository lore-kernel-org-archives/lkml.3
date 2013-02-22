Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3BVH5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:57:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9334 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3BVH5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:57:31 -0500
X-AuditID: cbfee68e-b7fc26d000001938-4a-512724e9b369
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, "'Tejun Heo'" <tj@kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20130222065345.GA30816@core.coreip.homeip.net>
 <000c01ce10cb$fdd4a4a0$f97dede0$%han@samsung.com>
 <20130222072635.GB30816@core.coreip.homeip.net>
In-reply-to: <20130222072635.GB30816@core.coreip.homeip.net>
Subject: RE: Dangerous devm_request_irq() conversions
Date: Fri, 22 Feb 2013 16:57:29 +0900
Message-id: <001301ce10d2$42e8e960$c8babc20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QzfSysoI6QAPmRsefd9wGJ4+CQAAApPww
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zI92XKuqBBh3z5Swu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG9UMzmQpWSFa0TlzP0sB4RKSLkZNDQsBE4seJM8wQtpjEhXvr
	2boYuTiEBJYxSjxfu58ZpujzzDZGiMQiRoljRxeyQzizmSRWNb5hB6liE1CT+PLlMJDNwSEi
	YCgxY00VSA2zwGtGiV93PrJCNCxklGj8sBJsLKeAjcT19z8ZQWxhAVOJ7hkbweIsAqoSkzon
	gsV5BWwlPs3fwAxhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZpDFEgLqEo/+6oKERQSMJGZv
	u8oGUSIise/FO7APJARWsUt0bvzKBLFLQOLb5EMsEL2yEpsOQH0sKXFwxQ2WCYwSs5BsnoVk
	8ywkm2chWbGAkWUVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRkh09e1gvHnA+hBjMtD6icxS
	osn5wOjMK4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFqUXxRaU5q8SFGJg5O
	qQZGw3l/xJd1Z9+Ju954SzYsdFNDr0Jl9Nn3rXK+9++ZadpZBbjsV5rcxTjn6Ftf3lw+w1Nz
	Aou2Vbc6PozLiNqe5BasvMd/ZVjPCk2F9Zr3rk5fIbL/9nfxe/N/e+yta89O7+3v+8Xu+Wlj
	4jdVD+9b865Zbwp+GBsrf5DniELQSRXRXPel618rsRRnJBpqMRcVJwIAL9sm6cQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xgO5LFfVAg7ONUhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/qhmUwFKyQrWieuZ2lg
	PCLSxcjJISFgIvF5ZhsjhC0mceHeerYuRi4OIYFFjBLHji5kh3BmM0msanzDDlLFJqAm8eXL
	YSCbg0NEwFBixpoqkBpmgdeMEr/ufGSFaFjIKNH4YSUzSAOngI3E9fc/wVYIC5hKdM/YCBZn
	EVCVmNQ5ESzOK2Ar8Wn+BmYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMoMslhBQl3j0Vxck
	LCJgJDF721U2iBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnF
	pXnpesn5uZsYwbH7TGoH48oGi0OMAhyMSjy8DS5qgUKsiWXFlbmHGCU4mJVEeBcpqAcK8aYk
	VlalFuXHF5XmpBYfYkwGenQis5Rocj4wreSVxBsam5gZWRqZWRiZmJuTJqwkzst46kmAkEB6
	YklqdmpqQWoRzBYmDk6pBsZ9raptJTVcdrwa1owBWzk3BlQ43vbys1ywKce8onLtnndS/3Ju
	f0+6vW5TeZtJ2q1pNx6v3OFxaK7bvZqMRWePfz0154C1fp/5qYx2T7uI6vSnIey5fDtKbHYc
	4poUPjGtZMGEgj/LJ3696qbX8rmn3fzcRd4rxU8SUzpLqxZV7Yq6rSG/+YgSS3FGoqEWc1Fx
	IgD+mnlNIQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 4:27 PM, Dmitry Torokhov wrote:
> On Fri, Feb 22, 2013 at 04:12:36PM +0900, Jingoo Han wrote:
> > On Friday, February 22, 2013 3:54 PM, Dmitry Torokhov wrote:
> > >
> > > Hi,
> > >
> > > It looks like a whole slew of devm_request_irq() conversions just got
> > > applied to mainline and many of them are quite broken.
> > >
> > > Consider fd5231ce336e038037b4f0190a6838bdd6e17c6d or
> > > c1879fe80c61f3be6f2ddb82509c2e7f92a484fe: the drivers udsed first to
> > > free IRQ and then unregister the corresponding device ensuring that IRQ
> > > handler, while it runs, has the device available. The mechanic
> > > conversion to devm_request_irq() reverses the order of these operations
> > > opening the race window where IRQ can reference device (or other
> > > resource) that is already gone.
> > >
> > > It would be nice if these could be reverted and revioewed again for
> > > correctness.
> >
> > Um, other RTC drivers already have been using devm_request_threaded_irq() or
> > devm_request_irq() like this, before I added these patches.
> >
> > For example,
> > ./drivers/rtc/rtc-tegra.c
> > ./drivers/rtc/rtc-spear.c
> > ./drivers/rtc/rtc-s3c.c
> > ./drivers/rtc/rtc-mxc.c
> > ./drivers/rtc/rtc-ds1553.c
> > ./drivers/rtc/rtc-ds1511.c
> > ./drivers/rtc/rtc-snvs.c
> > ./drivers/rtc/rtc-imxdi.c
> > ./drivers/rtc/rtc-tx4939.c
> > ./drivers/rtc/rtc-mv.c
> > ./drivers/rtc/rtc-coh901331.c
> > ./drivers/rtc/rtc-stk17ta8.c
> > ./drivers/rtc/rtc-lpc32xx.c
> > ./drivers/rtc/rtc-tps65910.c
> > ./drivers/rtc/rtc-rc5t583.c
> >
> >
> > Also, even more, some RTC drivers calls rtc_device_unregister() first,
> > then calls free_irq() later.
> >
> > For example,
> > ./drivers/rtc/rtc-vr41xx.c
> > ./drivers/rtc/rtc-da9052.c
> > ./drivers/rtc/rtc-isl1208.c
> > ./drivers/rtc/rtc-88pm860x.c
> > ./drivers/rtc/rtc-tps6586x.c
> > ./drivers/rtc/rtc-mpc5121.c
> > ./drivers/rtc/rtc-m48t59.c
> >
> >
> > Please, don't argue revert without concrete reasons.
> 
> What more concrete reason do you need? I explained to you the exact
> reason on the patches I noticed before and also on the 2 commits
> referenced above: blind conversion to devm_* changes order of operation
> which may be deadly with IRQs (but others, like clocks and regulators,
> are important too).
> 
> The fact that crap slipped in the kernel before is not the valid reason
> for adding more of the same crap.
> 
> Please *understand* APIs you are using before making changes.
> 
> >
> > If these devm_request_threaded_irq() or devm_request_irq() make the problem,
> > devm_free_irq() will be added later.
> 
> And the point? If you use devm_request_irq() and then call
> devm_free_irq() manually in all paths what you achieved is waste of
> memory required for devm_* tracking.

CC'ed Al Viro, Tejun Heo


So, is there any report that the devm_request_threaded_irq() makes
the deadly problem related IRQ in such cases?

According to your comment, it seems that there is no reason to use
devm_request_irq() or devm_request_threaded_irq().

Please, argue that it would be better to deprecate devm_request_irq()
or devm_request_threaded_irq().


> 
> --
> Dmitry

