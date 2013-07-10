Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3GJOy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:54:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56584 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab3GJOyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:54:53 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-76-51dd75bcf7e3
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1373391071-6312-1-git-send-email-dianders@chromium.org>
 <1373411961-23812-1-git-send-email-dianders@chromium.org>
 <1373411961-23812-6-git-send-email-dianders@chromium.org>
In-reply-to: <1373411961-23812-6-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v2 5/5] mmc: dw_mmc: Set timeout to max upon resume
Date: Wed, 10 Jul 2013 23:54:52 +0900
Message-id: <002b01ce7d7d$6eb717c0$4c254740$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac58+xrir8BqLNvNRXuWXtVVf4RmrAAfkb1g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zse6e0ruBBi3zNCwer1nMZPFg3jY2
	i+2vN7JZnF12kM3i1ZEfTBbv5r1gtrjxq43V4vKuOWwWR/73M1qcuv6ZzWLVrj+MDtwesxsu
	snjsnHWX3aNn5xlGj0NX1jJ6XDnRxOrRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGWcfmRY8
	Zq54t2cOawNjO3MXIyeHhICJROudxewQtpjEhXvr2boYuTiEBJYxSqz42MkGU/Tz831GiMQi
	RonHX86zQjh/GCWWLDvIAlLFJqAl8ffNG7CxIgJeEi92P2AGKWIWeMIkce3jNaj2PYwSi7ru
	M4FUcQq4SUx+eBxoOQeHsIC7xKJ2A5Awi4CqxO1pS8BKeAVsJT6cOMIGYQtK/Jh8D2wZs4CB
	xPtZfawQtrzE5jVvmUHGSAioSzz6qwtxg5HErr7PUCUiEvtevAM7QUJgJofExKu9TBC7BCS+
	TT7EAtErK7HpADRYJCUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLUK07M
	LS7NS9dLzs/dxAiJ/d4djLcPWB9iTAZaP5FZSjQ5H5g68kriDY3NjCxMTUyNjcwtzUgTVhLn
	VWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAaLqSSXVn0tXDV4J+ycrIXvPa/HrTpluB
	bs3pnvvPsDNquj6eqxxvzxLMuatrk/os6WlXo7gOnI/59kqkYk5oTfXUjT8X/c9lLTumcuX6
	aqP689OFTFvXBwZnZ2a+OHGg9w2rwt1H+vzsUs7fXXvElkZscGprNxF/f2P7g3+T21d/3vFo
	/59jb5RYijMSDbWYi4oTAaxJEkkTAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jAd09pXcDDRbvULF4vGYxk8WDedvY
	LLa/3shmcXbZQTaLV0d+MFm8m/eC2eLGrzZWi8u75rBZHPnfz2hx6vpnNotVu/4wOnB7zG64
	yOKxc9Zddo+enWcYPQ5dWcvoceVEE6tH35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXb
	KnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2ppFCWmFMKFApILC5W0rfDNCE0xE3X
	AqYxQtc3JAiux8gADSSsY8w4+8i04DFzxbs9c1gbGNuZuxg5OSQETCR+fr7PCGGLSVy4t56t
	i5GLQ0hgEaPE4y/nWSGcP4wSS5YdZAGpYhPQkvj75g1Yt4iAl8SL3Q+YQYqYBZ4wSVz7eI0R
	omMPo8SirvtMIFWcAm4Skx8eZ+9i5OAQFnCXWNRuABJmEVCVuD1tCVgJr4CtxIcTR9ggbEGJ
	H5PvgS1jFjCQeD+rjxXClpfYvOYtM8gYCQF1iUd/dSFuMJLY1fcZqkREYt+Ld4wTGIVmIZk0
	C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcGJ5JrWDcWWDxSFGAQ5G
	JR7ehvi7gUKsiWXFlbmHGCU4mJVEeNWtgEK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0x6
	eSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA6LA1xJ1Tsp83
	Vquu9siUaB6Hj8pTy2//e3cy6oidPpPp+20yBUJFs68xTdd6176Cu06yf+JDHsUDUR9THCqU
	f13fPGVD9fqzXQfTPmgKzDS0mF4aZHPU5M7lD3kCnEc/7Gy4fSHbYe5P0Tt3uVea/Dt3Tn5R
	QZ/Q5lnuB7Z//pXCv6J3zWLPx0osxRmJhlrMRcWJANZmBntwAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, July 10, 2013, Doug Anderson wrote:
> The TMOUT register is initted to 0xffffffff at probe time but isn't
> initted after suspend/resume.  Add an init of this value.
> 
> No problems were observed without this (it will also get initted in
> __dw_mci_start_request if there is data to send), but it makes the
> register dump before and after suspend clean.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

