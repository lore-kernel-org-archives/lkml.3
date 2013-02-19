Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab3BSCvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:51:21 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52963 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab3BSCvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:51:19 -0500
X-AuditID: cbfee68f-b7f656d000000d78-b6-5122e8a6fb48
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: "'linux-fbdev'" <linux-fbdev@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [GIT PULL] samsung-fb updates for v3.9
Date: Tue, 19 Feb 2013 11:51:17 +0900
Message-id: <003901ce0e4b$fd839c40$f88ad4c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4OS/1fL9hv0snASVq56iN5hSEFSA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t8zA91lL5QCDR6tZbM40feB1eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXMm/GWteAIV8WTRcdZGhhPcHQxcnJICJhIrJ87gQXC
	FpO4cG89WxcjF4eQwDJGiRkz25lgihbv+gOVWMQo0XPqDyuE84tR4kvDMVaQKjYBNYkvXw6z
	g9giQB0PPi5kBCliFnjLKPHx0V5GkISwgL7E5d3rwcayCKhKXH/4FszmFbCVuHDpIZQtKPFj
	8j2wm5gFtCTW7zzOBGHLS2xe85a5i5ED6CR1iUd/dSF26UkcPdHOCFEiIrHvxTuwvRIC/ewS
	Z7atYYTYJSDxbfIhFoheWYlNB5ghPpOUOLjiBssERrFZSDbPQrJ5FpLNs5CsWMDIsopRNLUg
	uaA4Kb3IWK84Mbe4NC9dLzk/dxMjJG76dzDePWB9iDEZaP1EZinR5Hxg3OWVxBsaG5uYmZia
	mFuampuSJqwkzit/SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2PttJocZjeraw4iE7V4
	shOlM+dLPj1XnfY2M9ZHbZftnQCW1gD9okvqcQ91Dxk3ShnvF0hsN6+LmrnoWubmCLbb2xRk
	gpbPsjvAeFz+u0nv8+T287H3WArXrzwReF8n7r2UvfChpXH1aokT1V4UncndemdNfcwqPfsj
	+8xYVLjPy62aG31AW4mlOCPRUIu5qDgRACVWUmexAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAd1lL5QCDS5eYLI40feB1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmzJvxlrXgCFfF
	k0XHWRoYT3B0MXJySAiYSCze9YcNwhaTuHBvPZDNxSEksIhRoufUH1YI5xejxJeGY6wgVWwC
	ahJfvhxmB7FFgLoffFzICFLELPCWUeLjo72MIAlhAX2Jy7vXM4HYLAKqEtcfvgWzeQVsJS5c
	eghlC0r8mHyPBcRmFtCSWL/zOBOELS+xec1b5i5GDqCT1CUe/dWF2KUncfREOyNEiYjEvhfv
	GCcwCsxCMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgqHwmvYNx
	VYPFIUYBDkYlHt4PjkqBQqyJZcWVuYcYJTiYlUR4O9qBQrwpiZVVqUX58UWlOanFhxiTgR6d
	yCwlmpwPTBh5JfGGxiZmRpZGZhZGJubmpAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoGx
	S4hL1XPel4fLmiYJP/YUVNZbuMx0LaOiT0D7Ghaupc+cAuzeSOS2983LNFs090qcz5596SXv
	eLpPVN68VlnCpMV59OEH27dtNgK62vp7mDb/sL1xdYH7266kLz6vX6wSX59rnF2yzebVs08y
	WZvC3LSnJjduy9m2zOjUg8dTHdiev95nu+mKEktxRqKhFnNRcSIA4AJtUA4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Florian, the fbdev maintainer, has been very busy lately, so I send the pull request
for samsung-fb for this merge window.

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

 Linux 3.8 (Mon Feb 18 15:58:34 2013 -0800)

are available in the git repository at:
  git://github.com/jingoo/linux.git samsung-fb-next

for you to fetch changes up to 5a415ae252d5922de9eadefabe8510115395fbc6:

 video: s3c-fb: Fix typo in definition of VIDCON1_VSTATUS_FRONTPORCH value (Sat Nov 17 21:31:00 2012 +0000)

----------------------------------------------------------------
samsung-fb updates for the v3.9:

- The bit definitions of header file are updated.
- The dependancy is fixed.
----------------------------------------------------------------

Jingoo Han (4):
      video: s3c-fb: use ARCH_ dependancy
      video: s3c-fb: remove duplicated S3C_FB_MAX_WIN
      video: s3c-fb: remove unnecessary brackets
      video: s3c-fb: add the bit definitions for CSC EQ709 and EQ601

Tomasz Figa (1):
      video: s3c-fb: Fix typo in definition of VIDCON1_VSTATUS_FRONTPORCH value

 drivers/video/Kconfig        |    3 +-
 include/video/samsung_fimd.h |  205 ++++++++++++++++++++---------------------
 2 files changed, 102 insertions(+), 106 deletions(-)

--
Best regards,
Jingoo Han

