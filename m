Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbaLIBPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:15:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15896 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaLIBPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:15:00 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-28-54864d11b78a
Message-id: <54864D11.7010008@samsung.com>
Date: Tue, 09 Dec 2014 10:14:57 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/19] clk: samsung: exynos5433: Add clocks for CMU_PERIS
 domain
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-5-git-send-email-cw00.choi@samsung.com>
 <54858C3C.9020701@samsung.com>
In-reply-to: <54858C3C.9020701@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SaUiTYRzv2Xv6lvi6nD2NDhwdomTNq0eK6uP6IAmZRFD6Zi9T0qmbk+pL
	S0vxSJaTNM0a5pUMpa3DNI9mHjhMTdOFOSXLEpUwtWOptLkiv/2e//93PfCnMeE8LqbjFam8
	UsElSEgGN3gFp+zzDM+MPGCtDESThgcCtFLQSaGvVXkADbb6o/uvXhNoWXuDRAXjWhxZ7ZkE
	uql/S6Le9FkKGSeHCTTYeJdExX0tDun7VRJVjgwIUM/IAonKnyxSqH02i0DFumkS1TYuAzQ9
	340fE8kM9wxA9tteAGTPS8YomaniqmyoO52Q5T+uBbIF444I6gxz+AKfEJ/GK/cfiWHiarq7
	yORv1KWxwiaBBnSQOcCNhmwwnFz6JHBhb9hvq3fMGVrIVgKYUV2I/yM9anhBuRZFAFY9WxG4
	HjMAlvd1rMndWT/YVzpFODHO7oZv7HmUE5OOeesX61qciI2CD4uGcBffE/7U2dawF+sPswdt
	hNMUY5cxaGlvBjmApjc7BHVlJ1xhegB7sybWAtwcAvuPRYGTg7EBcHzAzznG2J3QZJjDnHzI
	ttEwt8XytxALv+vMuJMP2e3Q2Ia5frYVvqyx4lrgXbKuUsl/15J1rnqA1QIRnxybrDovVwYH
	qLhElVohD4hNSjQCxyVYVqe0DcDWdsgMWBpINrn7hmVGCgkuTXU50QxCHCVuYWJRbJLjeBSp
	0dKg0EAUEhwSFHgwLFSyxX1G/OukkJVzqfxFnk/mldFKdQKvMgMB7SbWAHepubFeKo8+ynw4
	VT9kGlVH2jZqh27PPW0NI6ojU3pI8myXdddokSif8fCd6IiXd5ZuuNPVZB/dJvTMuGbak93Y
	YjzOeH3kh5eYxM+WDLNkb1mFWhEhu3JOqOtbpd5xHj5ss+a0soUzJZAVGi7c53qUui4kplPf
	n68tzpXgqjhO6ocpVdwfXW97UwQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQV1B37YQg+75mhaP1yxmsvg76Ri7
	xftlPYwWl/drW8w/co7V4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWmx5fY7W4vGsOm8WM
	8/uAWu/8Y7NYev0ik8Wp65/ZLBZt/cJucfhNO6vFjMkv2SxW7frDaPHy4wkWB1GPNfPWMHr8
	/jWJ0WPnrLvsHpuX1HtcOdHE6tG3ZRWjx+dNcgHsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHx
	zvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAXykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ
	9Q0JgusxMkADCWsYM1acOM5W8Im94u6U3UwNjEfZuhg5OSQETCQ27tjDDmGLSVy4tx4ozsUh
	JDCdUWLZ9r9MEM5rRolF548ygVTxCmhJnJ/9jBXEZhFQlbj0qwesmw0ovv/FDbCpogJhEiun
	X2GBqBeU+DH5HpgtIqAt0Xn5HivIUGaBP8wSpw/vZexi5OAQBmpYN9cfYtkCRomz7Q/AFnAC
	Nfz6/oUJpIZZQE/i/kUtkDCzgLzE5jVvmScwCsxCsmIWQtUsJFULGJlXMYqmFiQXFCel5xrq
	FSfmFpfmpesl5+duYgQnnGdSOxhXNlgcYhTgYFTi4dW0bAsRYk0sK67MPcQowcGsJMK7fGdr
	iBBvSmJlVWpRfnxRaU5q8SFGU2AATGSWEk3OBybDvJJ4Q2MTMyNLI3NDCyNjcyVxXiV7oDkC
	6YklqdmpqQWpRTB9TBycUg2MJhGh3/oOOql08two0Q69+PxD/UeGkLKTEqXPNq1RachXFayW
	+O1z9lhAs+Lt3WIHt/Zeemr2O+/n0Us3F+y56pST7vn1y4lL3pMyAl5ei/NuKvU8lLM+dv83
	t7AvR7cWxx6Y9fBX3YHHP4SeLy1gkZ73VXS7QO3H7cfL7BexJ976t6cp4dkJVyWW4oxEQy3m
	ouJEAEeYmsZOAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 12/08/2014 08:32 PM, Pankaj Dubey wrote:
> Hi Chanwoo,
> 
> On Tuesday 02 December 2014 02:19 PM, Chanwoo Choi wrote:
>> This patch adds missing gate clocks of CMU_PERIS domain
>> which includes TMU/TZPC/SECKEY/CHIPID/TOPRTC/EFUSE IPs.
>> The special clocks of CMU_PERIS use fin_pll source clock directly.
>>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>> ---
>>   drivers/clk/samsung/clk-exynos5433.c   | 146 ++++++++++++++++++++++++++++++++-
>>   include/dt-bindings/clock/exynos5433.h |  33 +++++++-
>>   2 files changed, 176 insertions(+), 3 deletions(-)
>>
> 
> Verified all registers and clock relationship against UM I have, and changes are OK.
> 
> Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Thanks for your review.

Best Regards,
Chanwoo Choi

