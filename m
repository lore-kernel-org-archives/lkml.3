Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3FMMBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:01:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57607 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3FMMBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:01:31 -0400
X-AuditID: cbfee68f-b7f436d000000f81-8f-51b9b499c9b6
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Simon Glass'" <sjg@chromium.org>,
        "'Luigi Semenzato'" <semenzato@chromium.org>, ilho215.lee@samsung.com,
        eunki_kim@samsung.com, linux-kernel@vger.kernel.org
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
 <1371058399-31933-2-git-send-email-dianders@chromium.org>
In-reply-to: <1371058399-31933-2-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH 2/3] pinctrl: exynos: reorder xyz_irq_unmask() so future
 patch can ack
Date: Thu, 13 Jun 2013 21:01:29 +0900
Message-id: <150801ce682d$bd25a120$3770e360$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5nkvaSOmaIguh1T9ypxuWNP18oswAmqtHg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zI92ZW3YGGpw/aW5xdtlBNotnd64w
	Wxz9t5DRYsqf5UwWl3fNYbM4df0zm8Xnq19YLL5t2cZosWrXH0YHTo/ZDRdZPHbOusvucefa
	HjaPKyeaWD36tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoErY96SD4wFzUwVTy4/YGxgPM/YxcjJ
	ISFgItG2cCuULSZx4d56ti5GLg4hgWWMEqdmPmCFKer40cICkZjOKDG7u4sZJCEk8JdRYt2M
	RBCbTUBD4vD7Z+wgtohApMSEA+eYQRqYBd4wSix//o4VoruRUWLDoldgYzkF3CR2f5wFtI+D
	Q1ggRmJurx+IySKgKnHxiydIBa+ArcSCi5uYIWxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsM
	0iohoC7x6K8uxAlGEl9WbGaGKBGR2PfiHSPIBRICvRwSuzb8BLuARUBA4tvkQywQvbISmw4w
	Q/wrKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kbFecWJucWleul5yfu4m
	Rkhs9+9gvHvA+hBjMtD6icxSosn5wNSQVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJ
	anZqakFqUXxRaU5q8SFGJg5OqQbGLbMUd9XonMkzmHtu28WTGf/k6hP9v2beVN54gZOxymaq
	nLeN5mFb7ufCX/+easy5nFAUps7blPj4ud26C91nQ/6JbVjiHDN1ldfrdv4bO9e2TS+9cejw
	+ZfrP56+WpvEJVl76vQSq6y+AMG3h09M1YnxsN3B288jonqaqSGw993tXfwevDeylFiKMxIN
	tZiLihMBfJyxwQMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsVy+t9jQd2ZW3YGGhybbWxxdtlBNotnd64w
	Wxz9t5DRYsqf5UwWl3fNYbM4df0zm8Xnq19YLL5t2cZosWrXH0YHTo/ZDRdZPHbOusvucefa
	HjaPKyeaWD36tqxi9Pi8SS6ALaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJc
	SSEvMTfVVsnFJ0DXLTMH6CwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEd
	Y8a8JR8YC5qZKp5cfsDYwHiesYuRk0NCwESi40cLC4QtJnHh3nq2LkYuDiGB6YwSs7u7mEES
	QgJ/GSXWzUgEsdkENCQOv3/GDmKLCERKTDhwjhmkgVngDaPE8ufvWCG6GxklNix6xQpSxSng
	JrH74yygsRwcwgIxEnN7/UBMFgFViYtfPEEqeAVsJRZc3MQMYQtK/Jh8D+wgZgEtifU7jzNB
	2PISm9e8ZQZplRBQl3j0VxfiBCOJLys2M0OUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKs
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOHM+kdjCubLA4xCjAwajEw/uidUegEGtiWXFl
	7iFGCQ5mJRHem1N3BgrxpiRWVqUW5ccXleakFh9iTAb6cyKzlGhyPjCp5ZXEGxqbmBlZGplZ
	GJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo0n5xj8S36aIHOT1V+bcc0Km/N3B
	GQ/+nVrPrep7Was7/vMDk88vuZ+WeLM3ff3k+GnbnbXzQkJX+i0x5L20M9Tr4qyuTp+Kmrvv
	lzxkWBvnzig1RfvTo4eSx2byn1yvs3njhVdHL/Tr62s2uR0xftt0VnElt5WRdqjc3T2e6zsV
	C77lPIs55qXEUpyRaKjFXFScCAABzoTOYAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> This patch does nothing but reorder the functions to improve the
> readability of a future patch.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
- Kukjin

