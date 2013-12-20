Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab3LTC2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 21:28:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20026 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3LTC2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 21:28:16 -0500
X-AuditID: cbfee68e-b7f566d000002344-92-52b3ab3ea6e9
From: Jingoo Han <jg1.han@samsung.com>
To: "'micky'" <micky_ching@realsil.com.cn>,
        "'Francis Moreau'" <francis.moro@gmail.com>,
        "'wwang'" <wei_wang@realsil.com.cn>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>, "'Chris Ball'" <cjb@laptop.org>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20131117195358.GO27323@pd.tnic>
 <4523614.I5MBhorHFt@vostro.rjw.lan> <5292FF5D.1050304@gmail.com>
 <1821758.2MoNI3h1Mv@vostro.rjw.lan> <52985041.5050000@gmail.com>
 <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de>
 <5299FF38.7060203@gmail.com>
 <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de>
 <529D92D6.8050409@gmail.com> <20131209221721.GB8612@zurbaran>
 <52A670E4.5050501@realsil.com.cn> <52A674E0.2080407@realsil.com.cn>
 <52B00547.8030904@gmail.com> <52B11EF6.3060606@realsil.com.cn>
 <52B158DD.2070603@gmail.com> <52B39DBF.4070104@realsil.com.cn>
In-reply-to: <52B39DBF.4070104@realsil.com.cn>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Date: Fri, 20 Dec 2013 11:28:13 +0900
Message-id: <002e01cefd2b$22362d40$66a287c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac79IumWBnFLE441RcKZ/9cANcBOXwAB8xOw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zsa7d6s1BBq/P81h83vCPzWL7641s
	Fi/7/rBaXF54idXi/tejjBaXd81hs+i5MJvF4sxpoNjpblaLzZumMlusXHeazYHb43trH4vH
	zll32T0OXVnL6HHn2h42j3fnzrF7zDsZ6PFjwztGjy1X21k8+rasYvT4vEkugCuKyyYlNSez
	LLVI3y6BK+Nkw1LmgqNMFRs2/2VtYPzB2MXIySEhYCJxev9sJghbTOLCvfVsXYxcHEICyxgl
	DnzbwQxT1H/4OztEYhGjxO+jO5khnF+MElu6O9hAqtgE1CS+fDnMDmKLgFR1bY4DKWIW6GaS
	+NnzEaxISGAmq8SdX5EgNqeAnsS8xZfB7hAW8JJ4e2sWWDOLgKrEmmUbwep5BWwlXk9dwg5h
	C0r8mHyPBcRmFtCSWL/zOBOELS+xec1boIs4gE5Vl3j0VxfiBiOJ/rnX2CBKRCT2vXjHCHKP
	hMBKDonLHQdZIXYJSHybfIgFoldWYtMBqI8lJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxi
	FE0tSC4oTkovMtIrTswtLs1L10vOz93ECEkLfTsYbx6wPsSYDLR+IrOUaHI+MK3klcQbGpsZ
	WZiamBobmVuakSasJM676GFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGtVvkdWMv77/y
	r8jKcz2Xtb+AfrD95PtuoQlSQbu/nPEvNTZcsn9vozCXy9yvZw96JXVv2bE7tuPx3N3F3XKv
	uHmX3Xl8oePZ1DSdPZKfog40u3P/nenbsiXvqvrBtup10Zu8F84wschrPlKa3tSUsiFb4Zrl
	Yu5+Wd0Zft/a5+yS1v2tsH67EktxRqKhFnNRcSIAMnnYNyEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t9jAV271ZuDDLb/Y7f4vOEfm8X21xvZ
	LF72/WG1uLzwEqvF/a9HGS0u75rDZtFzYTaLxZnTQLHT3awWmzdNZbZYue40mwO3x/fWPhaP
	nbPusnscurKW0ePOtT1sHu/OnWP3mHcy0OPHhneMHluutrN49G1ZxejxeZNcAFdUA6NNRmpi
	SmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDJSgpliTmlQKGA
	xOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMkw1LmQuOMlVs2PyXtYHxB2MXIyeHhICJ
	RP/h7+wQtpjEhXvr2boYuTiEBBYxSvw+upMZwvnFKLGlu4MNpIpNQE3iy5fDYB0iIFVdm+NA
	ipgFupkkfvZ8BCsSEpjJKnHnVySIzSmgJzFv8WWwdcICXhJvb80Ca2YRUJVYs2wjWD2vgK3E
	66lL2CFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3kLdBEH0KnqEo/+6kLcYCTRP/caG0SJiMS+
	F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCk80x6
	B+OqBotDjAIcjEo8vAX6m4OEWBPLiitzDzFKcDArifCumA0U4k1JrKxKLcqPLyrNSS0+xJgM
	9OhEZinR5HxgQswriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6p
	BsaFs+pn3P+d6+LK37Vxa9OSlwcuLjEI6Oy6GFv9bfnDxj3MVo7nNqf5iU0yLO+c/Z1/zz7d
	G3YpoY8EKt4tjdKevID5Z5nnvfev/1+/pKl3ysZeyT/mwOwNqg9N88/EvN+4Jrx94adVOeef
	2vU4PP7F8HOdjOuUN9dSdRL9d2ptrFo2/ZVUYJ63EktxRqKhFnNRcSIAq0UTx34DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 20, 2013 10:31 AM, micky wrote:
> 
> Hi Francis,
> 
> We are trying to get the environment same with yours,  so it may take
> some to solve this problem.
> maybe next month.

Yes, in this case, the problem should be reproduced.
And then, try debugging repeatedly.

Best regards,
Jingoo Han

