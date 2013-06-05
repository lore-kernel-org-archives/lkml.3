Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab3FEXcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:32:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35468 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3FEXcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:32:07 -0400
X-AuditID: cbfee691-b7fef6d000002d62-10-51afca746684
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Simon Glass'" <sjg@chromium.org>, linux-samsung-soc@vger.kernel.org,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1370397539-21653-1-git-send-email-dianders@chromium.org>
 <1370465793-7997-1-git-send-email-dianders@chromium.org>
 <CAOesGMhQX9ip=nb9AQa5fcDFRNpZZSxUO0N0GTX051dakWZD9Q@mail.gmail.com>
In-reply-to: <CAOesGMhQX9ip=nb9AQa5fcDFRNpZZSxUO0N0GTX051dakWZD9Q@mail.gmail.com>
Subject: RE: [PATCH v2] ARM: exynos: add debug_ll_io_init() call in
 exynos_init_io()
Date: Thu, 06 Jun 2013 08:32:04 +0900
Message-id: <09ca01ce6244$e2f0e7a0$a8d2b6e0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5iMV1ibvuwwt/TRka2YoOMMxU3NQAEyKAA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zA92SU+sDDRpmGFhMWneAyeLssoNs
	FpseX2O1uLxrDpvFjPP7mCxuX+a1OHX9M5vFty3bGC2OzVjCaLFq1x9GBy6PluYeNo/ZDRdZ
	PP6uesHssXPWXXaPO9f2sHlsXlLvceVEE6vH501yARxRXDYpqTmZZalF+nYJXBk37s9mLpjE
	UbG3eRVjA+NGti5GTg4JAROJW3sXs0DYYhIX7q0HinNxCAksY5RYN2MKI0zR66UzmCES0xkl
	/jW/Y4Rw/jJKPH87FaydTUBD4vD7Z+wgtoiAn8SGzg0sIEXMAluYJN407Iaae5xR4s2kI8wg
	VZwCwRIzjq1j7WLk4BAWCJP4PxmsmUVAVeLC2V2sIDavgK3EgkNfWSBsQYkfk++B2cwCWhLr
	dx5ngrDlJTavecsMMkZCQF3i0V9dEFNEwEji174aiAoRiX0vIG6WEJjKIfHnynMWiFUCEt8m
	H2KBaJWV2HSAGeJhSYmDK26wTGCUmIVk8Swki2chWTwLyYoFjCyrGEVTC5ILipPSi0z1ihNz
	i0vz0vWS83M3MULifuIOxvsHrA8xJgOtn8gsJZqcD0wbeSXxhsZmRhamJqbGRuaWZqQJK4nz
	qrdYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpg1JsjteOEHXOfbsabR9N0Lz56tuM6c9sS
	27Z+cSXjDa+yt/GpuAhF1rbeF/vTvPnq0yjne5+6dpl07Lj1cJ79g8TC4O2ZIRpz2E+f3B6Q
	ekfz+714u26hWm7OAgOry90T3kzlFio+l6Np/WSS3MF84zmX6uWEc45GH5BZLMu5RNrkkvO6
	aWvTlFiKMxINtZiLihMBvR8v+xEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jQd2SU+sDDe5M0baYtO4Ak8XZZQfZ
	LDY9vsZqcXnXHDaLGef3MVncvsxrcer6ZzaLb1u2MVocm7GE0WLVrj+MDlweLc09bB6zGy6y
	ePxd9YLZY+esu+wed67tYfPYvKTe48qJJlaPz5vkAjiiGhhtMlITU1KLFFLzkvNTMvPSbZW8
	g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4BuVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jFm3Lg/m7lgEkfF3uZVjA2MG9m6GDk5JARMJF4vncEMYYtJXLi3HijO
	xSEkMJ1R4l/zO0YI5y+jxPO3U1lAqtgENCQOv3/GDmKLCPhJbOjcwAJSxCywhUniTcNuqPbj
	jBJvJh0Bm8spECwx49g61i5GDg5hgTCJ/5PBmlkEVCUunN3FCmLzCthKLDj0lQXCFpT4Mfke
	mM0soCWxfudxJghbXmLzmrfMIGMkBNQlHv3VBTFFBIwkfu2rgagQkdj34h3jBEahWUgGzUIy
	aBaSQbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxUnknvYFzVYHGIUYCDUYmH
	VyJgfaAQa2JZcWXuIUYJDmYlEd5/FUAh3pTEyqrUovz4otKc1OJDjMlAf05klhJNzgcmvLyS
	eENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYAx6WrmX7+dpl3MF
	ldKfBS5N/aZwT6aR4/dLthS/RccM+u9cFUiWaZSRap3BeDY1Xf10qW6ekFR/5ErfKy9dWV29
	ovNdzE9PLbpSZ9lnn/cojGXe4V2Pm3mkwl7tcA54u8Z299l5O7NDT4v8NaqofXuFdfpiOebZ
	xxfZ3vnmlKL/UytZ9X+qmhJLcUaioRZzUXEiAHwaInJuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> 
> On Wed, Jun 5, 2013 at 1:56 PM, Doug Anderson <dianders@chromium.org>
> wrote:
> > If the early MMU mapping of the UART happens to get booted out of the
> > TLB between the start of paging_init() and when we finally re-add the
> > UART at the very end of s3c_init_cpu(), we'll get a hang at bootup if
> > we've got early_printk enabled.  Avoid this hang by calling
> > debug_ll_io_init() early.
> >
> > Without this patch, you can reliably reproduce a hang when early
> > printk is enabled by adding flush_tlb_all() at the start of
> > exynos_init_io().  After this patch the hang goes away.
> >
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> 
> Acked-by: Olof Johansson <olof@lixom.net>
> 
> 
> Kukjin, this seems appropriate for 3.10. Do you have other fixes
> queued or should I apply this directly?
> 
If I remember correctly, nothing in my tree for 3.10.

So please go ahead with my ack if you want,

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

