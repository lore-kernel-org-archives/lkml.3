Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3CNKeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:34:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40051 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab3CNKeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:34:03 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-14-5141a79a8303
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'James Hogan'" <james.hogan@imgtec.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>
References: <1363085012-9220-1-git-send-email-james.hogan@imgtec.com>
 <002301ce1ff5$e42f8090$ac8e81b0$%jun@samsung.com> <51408F1D.8010600@imgtec.com>
In-reply-to: <51408F1D.8010600@imgtec.com>
Subject: RE: [PATCH] mmc: dw_mmc: setpower on MMC_POWER_{UP,OFF}
Date: Thu, 14 Mar 2013 19:34:01 +0900
Message-id: <002101ce209f$716f1fc0$544d5f40$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4f+FBOBQM3LbUST8iuWqUW+0sdRQApc4BQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zfd1Zyx0DDX6eFbbY/nojm8W7eS+Y
	LW78amO1uLxrDpvFkf/9jA6sHj07zzB6HLqyltGjb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	MlZNbWcuWCdeMfGyUwPjNaEuRk4OCQETiecNh1ghbDGJC/fWs3UxcnEICSxjlFjY08cKU3Rw
	aQ8rRGI6o8TNtTtYQBJCAn8YJW4vCAKx2QS0JP6+ecPcxcjBIQJkH2o0AKlnFmhjlDj38hJC
	c9OH98wgDZxARd9fX2QEsYUFHCTOHZwPZrMIqErcvb8LbAGvgK3E/u9TGSFsQYkfk++BxZkF
	DCTez4K4jllAXmLzmrdgiyUE1CUe/dUFCYsIGEl0LfrOCFEiIrHvxTtGkBskBC6xS6yc9JIF
	YpeAxLfJh1ggemUlNh1ghnhYUuLgihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0
	ImO94sTc4tK8dL3k/NxNjJD47N/BePeA9SHGZKD1E5mlRJPzgfGdVxJvaGxmZGFqYmpsZG5p
	RpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGL/MFxaEhrH+CP+k3bZ58yVKP
	aeKG4z9Tnrzh2Ks/wS+Me1m2z/SuvnVv2haulJjr/WWNl1HyvTchn0Vrd78r2dqmuKPIqvrB
	1TV32H7ptW2ysIkprTWcH/n1teXGnjVbbxau+SRcYfNH0No/tUJrc9CeT26Wzc0vXl1p3Xbn
	QNseK8nZ1upvlViKMxINtZiLihMBDbHcueUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd1Zyx0DDQ5+4LPY/nojm8W7eS+Y
	LW78amO1uLxrDpvFkf/9jA6sHj07zzB6HLqyltGjb8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwnrGDNWTW1nLlgnXjHxslMD4zWhLkZODgkBE4mDS3tYIWwx
	iQv31rN1MXJxCAlMZ5S4uXYHC0hCSOAPo8TtBUEgNpuAlsTfN2+Yuxg5OESA7EONBiD1zAJt
	jBLnXl5ihWtu+vCeGaSBE6jo++uLjCC2sICDxLmD88FsFgFVibv3d4Et4BWwldj/fSojhC0o
	8WPyPbA4s4CBxPtZfawQtrzE5jVvwRZLCKhLPPqrCxIWETCS6Fr0nRGiRERi34t3jBMYhWYh
	mTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw9D+T2sG4ssHiEKMA
	B6MSD++BfodAIdbEsuLK3EOMEhzMSiK8nl6OgUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqc
	D0xMeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAGHf1oGrQ
	qZ2/M1yb/i1yvNUcfm/Dpk1L2AO32tpYViZ67hR/l79Qtth8b/is1bEz7onkKV12+NX75V31
	pqWrivOMytYrPeLKq7p5YP1lzhrrTxzbxE0zzijnCYr4KWf1R/EsYvseUGygdsJIY61F2Oww
	Xo3jW70V3jHsk5HtuzznXsThb8fWKbEUZyQaajEXFScCANrlGJpCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 13, 2013, James Hogan wrote:
> On 13/03/13 14:20, Seungwon Jeon wrote:
> > Hi James,
> >
> > On Tuesday, March 12, 2013, James Hogan wrote:
> >> Call the setpower platform callback in response to set_ios with
> >> ios->power_mode == MMC_POWER_UP or MMC_POWER_OFF, instead of from the
> >> card detect work function.
> >>
> >> This appears to fix a problem I have where a card stuck in a funny state
> >> doesn't get properly cleared by the power being turned off, presumably
> >> due to lack of power sequencing. This resulted in the following log
> >> messages after boot:
> >>
> >> mmc0: error -110 whilst initialising SD card
> >> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 300000Hz, actual 298922HZ div = 167)
> >> mmc0: error -110 whilst initialising SD card
> >> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 200000Hz, actual 199680HZ div = 250)
> >> mmc0: error -110 whilst initialising SD card
> >> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 195765Hz, actual 195764HZ div = 255)
> >> mmc0: error -110 whilst initialising SD card
> >> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 400000Hz, actual 399360HZ div = 125)
> >> mmc0: error -110 whilst initialising SD card
> >> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 300000Hz, actual 298922HZ div = 167)
> >>
> >> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> >> Cc: Seungwon Jeon <tgih.jun@samsung.com>
> >
> > This patch is reasonable.
> > I just want to know though.
> > I guess this problem is happened when card is inserted as soon as card is removed.
> > If not, could you explain your situation more?
> 
> Hi,
> 
> It initially started happening after the patch by Yuvaraj CD ("mmc:
> dw_mmc: enable controller interrupt before calling mmc_start_host").
> Basically after hard resetting the board the card would be in a dodgy
> state, and I'd get these elusive errors after boot (see the above patch
> thread for details). It was specifically the position of the prink that
> it was sensitive to (I have a JTAG console turned on which adds big
> latencies to prinks, so it's clearly some kind of race). Unplugging the
> card cleared the problem, as did cutting the power to the card for a
> sufficient amount of time. While trying to debug the messages I saw
> these power callbacks and thought I'd try them as they seem like a much
> better place to control the card power, and seem to match other host
> drivers too, and it fixed the problem, I presume due to the intentional
> delays around those calls. It is of course possible that the race is
> just hiding again, but I think the patch is an improvement regardless.
Thank you for your description.
I think the reason is insufficiency of power-on time.
Voltage level shall be below 0.5V at least 1ms when card power-on (from SD spec).
I'm adding...

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Thanks,
Seungwon Jeon

