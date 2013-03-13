Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab3CMOWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:22:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26483 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3CMOWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:22:43 -0400
X-AuditID: cbfee68e-b7f946d000001e37-ec-51408bb138c4
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Markos Chandras'" <markos.chandras@imgtec.com>,
        linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>
References: <1363085593-22214-1-git-send-email-markos.chandras@imgtec.com>
In-reply-to: <1363085593-22214-1-git-send-email-markos.chandras@imgtec.com>
Subject: RE: [PATCH 1/3] dw_mmc: Don't loop when handling an interrupt
Date: Wed, 13 Mar 2013 23:22:40 +0900
Message-id: <002501ce1ff6$38e3c470$aaab4d50$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4fEBFFQXQczuDeSaKJ422J86jj4gA5D5PA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zI92N3Q6BBp/2mVhsf72RzeLGrzZW
	i8u75rBZHPnfz2jx+fZ2VgdWj56dZxg9Dl1Zy+jRt2UVo8fnTXIBLFFcNimpOZllqUX6dglc
	GY9OLmUtuMtScemWTAPjK+YuRk4OCQETiSVtMLaYxIV769lAbCGBZYwS944nwNQ0bz3A3sXI
	BRSfzijxoOUrC4Tzh1HiR+9fVpAqNgEtib9v3oBNEhHwlTj39zs7iM0skC1xvLeJGWKql8T7
	pzvAbE4Bb4m25ilg24QF3CTuHO9jBLFZBFQlvu68AjaTV8BW4m/7BEYIW1Dix+R7LBAzDSTe
	z+pjhbDlJTaveQs0kwPoUnWJR391IU4wkpjafIYNokREYt+Ld4wgN0sIXGKXeLqklQlil4DE
	t8mHWCB6ZSU2HYAGhKTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UVGesWJ
	ucWleel6yfm5mxgh0dm3g/HmAetDjMlA6ycyS4km5wOjO68k3tDYzMjC1MTU2Mjc0ow0YSVx
	XrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJ7rrYr/J2x0nvSGYeq1QiGFM6/0V196
	ovmobPq8c1FauU3RFw045rR33zh6JoWpIkDp37qprOsa3zOtODfntK4jN/fkPLVDRy8dif/C
	kj99Q8aGdtPKxH+P1N0m5/3dOjtnT9vLGC0VmS0WCrec1LsFf25e9T1PdSMvT2mHgZJ7rdmT
	NUf5PJRYijMSDbWYi4oTAfkaFW7kAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd2N3Q6BBr/OGFhsf72RzeLGrzZW
	i8u75rBZHPnfz2jx+fZ2VgdWj56dZxg9Dl1Zy+jRt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYR1jBmPTi5lLbjLUnHplkwD4yvmLkZODgkBE4nmrQfYIWwx
	iQv31rN1MXJxCAlMZ5R40PKVBcL5wyjxo/cvK0gVm4CWxN83b8C6RQR8Jc79/Q7WzSyQLXG8
	twksLiTgJfH+6Q4wm1PAW6KteQobiC0s4CZx53gfI4jNIqAq8XXnFbCZvAK2En/bJzBC2IIS
	PybfY4GYaSDxflYfK4QtL7F5zVugmRxAl6pLPPqrC3GCkcTU5jNsECUiEvtevGOcwCg0C8mk
	WUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgqP/mdQOxpUNFocYBTgY
	lXh4Bb7aBwqxJpYVV+YeYpTgYFYS4V2e6xAoxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnA
	xJRXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyb+AVeml1U
	9rM9unqS1eT4mNUaszRZN0w/8Udh0zubOa5CNw/dd2jR9Y2xXjHtwlTTsjQZJkmB8le39ENU
	Gh9+3pHV2/zowvWvK2tknR8tv6vw5WJ9PrtPbPbNHI6lqo/XWdyLmRDkJVZyw5brm5Vy64Pr
	2eltxyY/k8yauNh8/5kGN9//TreUWIozEg21mIuKEwGxVEXnQgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 12, 2013, Markos Chandras wrote:
> There is no reason to loop when handling an interrupt. The "if" clauses
> will handle all of them sequentially. This also eliminates the extra loop
> we used to take with no pending interrupts and we ended up breaking out
> of the while loop.
> 
> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
> Cc: Seungwon Jeon <tgih.jun@samsung.com>

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

You can add my ack to other patches.
However, could you change the subject prefix to 'mmc: dw_mmc' and resend?

Thanks,
Seungwon Jeon

