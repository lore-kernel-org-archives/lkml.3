Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3FJIiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:38:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47209 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3FJIiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:38:03 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-84-51b59068a1cd
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Cc: "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Sean Paul'" <seanpaul@chromium.org>,
        "=?ISO-8859-1?Q?'St=E9phane_Marchesin'?=" <marcheu@chromium.org>
References: <003101ce4e1b$4acc0050$e06400f0$@samsung.com>
 <CAD=FV=UjohPBxChbE2R4b8JWCbxZRXVx_9WuMYPgHTehMP6vvg@mail.gmail.com>
In-reply-to: <CAD=FV=UjohPBxChbE2R4b8JWCbxZRXVx_9WuMYPgHTehMP6vvg@mail.gmail.com>
Subject: RE: [PATCH 2/2] ARM: dts: Document DP clock in samsung,exynos5-dp
 binding
Date: Mon, 10 Jun 2013 17:38:00 +0900
Message-id: <0ea301ce65b5$d0c265d0$72473170$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5OjihfQu8tHiV3TdGUE+9Z1GrZ9QXJ5xpw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zY92MCVsDDX7vsrE4u+wgm8XlhZdY
	LTY9vsZqcXnXHDaLGef3MVnMO/Sb0eLU9c9sFnc3nGW0ODZjCaMDp8fshossHneu7WHz2Lyk
	3uPKiSZWj74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4MqYMGUFa8FRloqrF2YxNTAeZO5i5OSQ
	EDCR+HB6CRuELSZx4d56IJuLQ0hgGaNEx+XnrDBFzxb+hUpMZ5RYs2AOC4Tzl1FizoVZYFVs
	AhoSh98/YwexRQT8JT5dPc0MUsQssJdJ4t/1p1DtDYwSN9bvBlvOKRAssWfndxYQW1ggRGJR
	9yImEJtFQFXi3aEGsDivgK3E8itvoGxBiR+T74HZzAI6Evtbp7FB2PISm9e8BZrJAXSrusSj
	v7oQRxhJ9E6+zg5RIiKx78U7RpAbJARaOSTalu9nh9glIPFt8iEWiF5ZiU0HoOEiKXFwxQ2W
	CYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkh89+5gvH3A
	+hBjMtD6icxSosn5wPSQVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxR
	aU5q8SFGJg5OqQZGv7eLDeK2i0ozyd1WFdwc+3WpWcXbu51PA6OqrNQ7sqIERL9eV1CYHFrM
	KSdxbsHlJxzqG5ZeuzV/7dlpuzed+hFfz2Dus+x8DKfH/SV2r4KjFzVcWbswbnmrpN8L4Zou
	l1snNO9u9ltgq2L4/aFWwlN/a+l/d91V/olOKvv4lH/KJvfkqG41JZbijERDLeai4kQA+w8U
	NgUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t9jQd2MCVsDDbbNtrA4u+wgm8XlhZdY
	LTY9vsZqcXnXHDaLGef3MVnMO/Sb0eLU9c9sFnc3nGW0ODZjCaMDp8fshossHneu7WHz2Lyk
	3uPKiSZWj74tqxg9Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdS
	yEvMTbVVcvEJ0HXLzAG6SkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY
	MWHKCtaCoywVVy/MYmpgPMjcxcjJISFgIvFs4V82CFtM4sK99UA2F4eQwHRGiTUL5rBAOH8Z
	JeZcmMUKUsUmoCFx+P0zdhBbRMBf4tPV08wgRcwCe5kk/l1/CtXewChxY/1usB2cAsESe3Z+
	ZwGxhQVCJBZ1L2ICsVkEVCXeHWoAi/MK2Eosv/IGyhaU+DH5HpjNLKAjsb91GhuELS+xec1b
	oJkcQLeqSzz6qwtxhJFE7+Tr7BAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5IL
	ipPSc430ihNzi0vz0vWS83M3MYKTxzPpHYyrGiwOMQpwMCrx8D74tSVQiDWxrLgy9xCjBAez
	kgjvrIatgUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0xseSXxhsYmZkaWRmYWRibm5qQJ
	K4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAaJ5xcP5+jks/LHNuPpP1Y17kL3jxYcvO9Kvl
	e7Z2P7P9u+ClafD5d1e7t/79q3VodXb2rFOzAzy0c981Bv75JOX6ZKZs7caV2sqt/b4r8vcc
	7Q7zmBB0VaftZKzN6ojPaUyf9q5ZojHPYFLa58O9T/9ktXh7Z2sJRX7uOL1sx6VlZvLXjDc+
	1lZiKc5INNRiLipOBAA33wF6YgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> Jingoo,
> 
> On Sat, May 11, 2013 at 12:43 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > The exynos5-dp node needs a clock specified using the common clock
> > framework.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> > Tested on Exynos5250
> >
> >  .../devicetree/bindings/video/exynos_dp.txt        |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> Thanks for updating the bindings.  This looks good.
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>

Applied, thanks.

- Kukjin

