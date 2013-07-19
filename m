Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab3GSE4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 00:56:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59406 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab3GSE4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 00:56:23 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-b2-51e8c6f519d3
Message-id: <51E8C6F4.6010204@samsung.com>
Date: Fri, 19 Jul 2013 13:56:20 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] extcon: arizona: Use power efficient workqueue
References: <1374183742-6678-1-git-send-email-broonie@kernel.org>
In-reply-to: <1374183742-6678-1-git-send-email-broonie@kernel.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWyRsSkSPfrsReBBpP+S1pMffiEzWLT9eus
	Fpd3zWGzuN24gs1i+dv/bA6sHptWdbJ53Lm2h83j5cTfbB59W1YxenzeJBfAGsVlk5Kak1mW
	WqRvl8CVcf7tXraCsywVd5sWMDcwXmfuYuTkkBAwkTi75ROULSZx4d56ti5GLg4hgaWMEnOn
	v4Mren3gKDNEYhGjxPyH11ggnFeMElsXHmMBqeIV0JJY0LqXDcRmEVCVWHZzDiOIzQYU3//i
	BlhcVCBMYuX0K1D1ghI/Jt8Ds0UElCWuft8LNpRZYDKjxM3368CahQWcJXpftLOD2EICjhLf
	DtwBG8Qp4CTRe+ke2HnMAjoS+1unsUHY8hKb17wFO1VCYB+7xJvj39khLhKQ+Db5ENAGDqCE
	rMSmA1CvSUocXHGDZQKj2CwkN81CMnYWkrELGJlXMYqmFiQXFCelF5noFSfmFpfmpesl5+du
	YgTG2el/zybsYLx3wPoQYzLQyonMUqLJ+cA4zSuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBI
	ID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY26NYoOwtnnow7ZN/x5F/awu/qn2xLaBhWG2cde+
	jxucfk7/lKW/bALPrJbTsiq18uecJR60Fv47+PfN+f/6q6eHeG8ynTJxgf/dNsMn6ttkpN7I
	m9lP/GjjUrRc6eyvy+t4S24tEWPsdnDvnnes2ijj7Jn43l9NepMXfudfPZnFZPazKet37FJi
	Kc5INNRiLipOBADL61X4yQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jAd2vx14EGvx+LGQx9eETNotN16+z
	WlzeNYfN4nbjCjaL5W//szmwemxa1cnmcefaHjaPlxN/s3n0bVnF6PF5k1wAa1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0HYlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8b5t3vZCs6yVNxtWsDcwHiduYuRk0NCwETi
	9YGjULaYxIV769m6GLk4hAQWMUrMf3iNBcJ5xSixdeExFpAqXgEtiQWte9lAbBYBVYllN+cw
	gthsQPH9L26AxUUFwiRWTr8CVS8o8WPyPTBbREBZ4ur3vWBDmQUmM0rcfL8OrFlYwFmi90U7
	O4gtJOAo8e3AHbBBnAJOEr2X7oGdxyygI7G/dRobhC0vsXnNW+YJjAKzkOyYhaRsFpKyBYzM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo/iZ1A7GlQ0WhxgFOBiVeHgffHkeKMSaWFZc
	mXuIUYKDWUmE91fyi0Ah3pTEyqrUovz4otKc1OJDjMnAIJjILCWanA9MMHkl8YbGJmZGlkbm
	hhZGxuakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwMh0T0rsitG84J+d9zN7XWf66bye
	3lH+3PBGfxXz1jbNmnWPfPSjaj7Gu07Uuytbtl9ujyZrc1uHlbP58yjdq8cE/Hr60jNNll1r
	fcw7W9+q7U1T6O+NMz+EB2c/FTspfuKd+CmTbysecGT/LvFr5Pj2umxevZlHZ7ur3f95p/oM
	BNSvhfirKrEUZyQaajEXFScCAC4Th5cmAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 07/19/2013 06:42 AM, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> None of the delayed work the driver schedules has particularly short delays
> and it is not performance sensitive so let the scheduler run it wherever
> is most efficient rather than in a per CPU workqueue by using the system
> power efficient workqueue.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/extcon/extcon-arizona.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 

Applied it.

Thanks,
Chanwoo Choi

