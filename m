Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab3BUFRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 00:17:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:8949 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3BUFRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 00:17:40 -0500
X-AuditID: cbfee68f-b7f656d000000d78-97-5125adf2603e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: "'linux-fbdev'" <linux-fbdev@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: 
In-reply-to: 
Subject: [GIT PULL] samsung-fb updates for v3.9
Date: Thu, 21 Feb 2013 14:17:38 +0900
Message-id: <00b801ce0ff2$c3dfa800$4b9ef800$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4OS/1fL9hv0snASVq56iN5hSEFSABphXNQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zY91Pa1UDDZZ06lmc6PvAanF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLuvd3KUnCCq2LWIoUGxjMcXYycHBICJhKfbzSwQNhi
	EhfurWfrYuTiEBJYxijRvPo7E0zR9ta1jBCJRYwSh3qus0A4vxglLs3fxgpSxSagJvHly2F2
	EFsEqOPBx4VgHcwCbxklPj7aC+RwAHVwS6xuDgKp4RTgkVj3p5MZxBYW0Je4vHs92DYWAVWJ
	fbMfg53EK2Arse7ZbFYIW1Dix+R7YHFmAS2J9TuPM0HY8hKb17xlBhkvIaAu8eivLsQJRhKn
	z61lhygRkdj34h0jxDOr2CVa17JArBKQ+Db5EAtEq6zEpgPMECWSEgdX3GCZwCgxC8niWUgW
	z0KyeBaSDQsYWVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525ihERY/w7GuwesDzEmA62fyCwl
	mpwPjNC8knhDY2MTMxNTE3NLU3NT0oSVxHnlL8kECgmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amAsWrC9KObOLzEBndPr/A2+/Ctp/HxV7ib7vmcprHcXmUZPmnM1Z6mEiNkpuXVeC/kN3p5I
	F6zLeufvfGp6xRdh1Y1Z59+/f35hiXHIv9bXIUu+bHq8U3G//s3fOib8oZoJRvdjdp39v+za
	80/1p58/1veXPqGjV53eo6vmNknRWMn1v9pEnjN7lViKMxINtZiLihMBT7+qnMYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd1Pa1UDDa7f1bA40feB1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm3Hu7laXgBFfF
	rEUKDYxnOLoYOTkkBEwktreuZYSwxSQu3FvP1sXIxSEksIhR4lDPdRYI5xejxKX521hBqtgE
	1CS+fDnMDmKLAHU/+LiQEaSIWeAto8THR3uBHA6gDm6J1c1BIDWcAjwS6/50MoPYwgL6Epd3
	r2cCsVkEVCX2zX7MAmLzCthKrHs2mxXCFpT4MfkeWJxZQEti/c7jTBC2vMTmNW+ZQcZLCKhL
	PPqrC3GCkcTpc2vZIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBEfwM6kdjCsbLA4xCnAwKvHwLnipEijEmlhWXJl7iFGCg1lJhPdnB1CI
	NyWxsiq1KD++qDQntfgQYzLQoxOZpUST84HJJa8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKE
	BNITS1KzU1MLUotgtjBxcEo1MPYZrl1xuGDri+0BL139fiRJBf7+87JAx3LNicoL/5n250eX
	LSmJym7w/XL5658zJrlBO6KL1E9omU2q/RJ++svkV0Umm9ZGVTbUhyb3Nj+N4f+17lrG9Ne8
	xj6uaZGLpBRKTBkmLU1LWzJBdJflP7cgzlup94z9+Z+lF5xnl3U3+xvAudropBJLcUaioRZz
	UXEiAODuQgYkAwAA
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
  git://github.com/jingoo/linux.git tags/samsung-fb-3.9

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

