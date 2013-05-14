Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3ENMZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:25:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19628 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3ENMZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:25:15 -0400
X-AuditID: cbfee68f-b7f436d000000f81-3e-51922d2aa300
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Simon Glass'" <sjg@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <1368039168-24447-1-git-send-email-dianders@chromium.org>
 <1368123170-22906-1-git-send-email-dianders@chromium.org>
 <CACRpkdZ3grCyf3x5dEbT6hAVDkpM3mwibVO5kT0Lv=a09-zBPA@mail.gmail.com>
In-reply-to: <CACRpkdZ3grCyf3x5dEbT6hAVDkpM3mwibVO5kT0Lv=a09-zBPA@mail.gmail.com>
Subject: RE: [PATCH v3] ARM: exynos: Select PINCTRL_EXYNOS for exynos4/5 at
 chip level
Date: Tue, 14 May 2013 21:25:13 +0900
Message-id: <093701ce509e$15ba0350$412e09f0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5Qm64EnLZgmOo5STOVi/IgN6B6MwAAlDAQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+Zsa6W7qRAg8svWC0ezNvGZnF22UE2
	iyl/ljNZbHp8jdXi8q45bBYzzu9jsrh9mdfi1PXPbBbftmxjtDg2YwmjxapdfxgduD1amnvY
	PGY3XGTx2DnrLrvHnWt72Dw2L6n3uHKiidWjb8sqRo/Pm+QCOKK4bFJSczLLUov07RK4Mm6c
	P85ScIe9Ys3nsgbGVrYuRk4OCQETie9/JkPZYhIX7q0Hsrk4hASWMUp82TmPCaZoxsrbzBCJ
	RYwSu060MEI4fxklvrb2sYJUsQloSBx+/4y9i5GDQ0QgUuLWY3aQGmaB70wSdxc8Y4doOMEo
	8WjDMrB9nALBEvMeNILZwgIREsvfPGcBsVkEVCUuTD8BtppXwFZi5rkd7BC2oMSPyffAapgF
	tCTW7zzOBGHLS2xe85YZZLGEgLrEo7+6IGERASOJH7duMUOUiEjse/EO7GgJgYUcEg3N/VC7
	BCS+TT7EAtErK7HpADPEx5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpRcZ
	6xUn5haX5qXrJefnbmKEJID+HYx3D1gfYkwGWj+RWUo0OR+YQPJK4g2NzYwsTE1MjY3MLc1I
	E1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwHjsjsx/q+ZJS/UXf25tjL17Nexu
	w/czM7cqeD44eMvL4W7M6z9reeZMC1xd1HpGWffX+1SfwMQrjpVJR9d9O21UybHj+02Fzxfr
	H9wUCuLesfi5CnP0lyxV768b96/hZ7aQvhRXfufraz7XBf8LjRKCf5k/+JPLZ3BdjOHNYdnn
	uUwH/3Q+W8ShxFKckWioxVxUnAgAIwb4shYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jAV0t3UmBBpOdLR7M28ZmcXbZQTaL
	KX+WM1lsenyN1eLyrjlsFjPO72OyuH2Z1+LU9c9sFt+2bGO0ODZjCaPFql1/GB24PVqae9g8
	ZjdcZPHYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS85LzUzLz
	0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA7lRSKEvMKQUKBSQWFyvp22GaEBri
	pmsB0xih6xsSBNdjZIAGEtYxZtw4f5yl4A57xZrPZQ2MrWxdjJwcEgImEjNW3maGsMUkLtxb
	DxTn4hASWMQosetECyOE85dR4mtrHytIFZuAhsTh98/Yuxg5OEQEIiVuPWYHqWEW+M4kcXfB
	M3aIhhOMEo82LANbwSkQLDHvQSOYLSwQIbH8zXMWEJtFQFXiwvQTTCA2r4CtxMxzO9ghbEGJ
	H5PvgdUwC2hJrN95nAnClpfYvOYtM8hiCQF1iUd/dUHCIgJGEj9u3WKGKBGR2PfiHeMERqFZ
	SCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnFyeSe9gXNVgcYhR
	gINRiYf3xY8JgUKsiWXFlbmHGCU4mJVEeC9zTwoU4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR
	5Hxg4ssriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsaZ+Xb/
	794JVu/n/T7bJybaJjFtD3MY+75lDGKK56fN7vM/KOfOXbliH2PuHj7J6ceD5eRF986smF+h
	sjjswXxvzWTl+D636bf+5L7QDInRyNhc/Of4TzYn+4SenDVffj175nLyafTpHS1lE/g9WTTL
	q8ouWnxSerzvSOScH2U/rPujznTf2KjEUpyRaKjFXFScCAB/qtFGcgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 
> On Thu, May 9, 2013 at 8:12 PM, Doug Anderson <dianders@chromium.org>
> wrote:
> 
> > Previously if you had MACH_EXYNOS5_DT but not MACH_EXYNOS4_DT you'd be
> > missing the pincontrol definitions.  Move PINCTRL selects to the arch
> > level since we should be enabling the code for all exynos variants.
> >
> > Update the PINCTRL descriptions to indicate that PINCTRL_EXYNOS is not
> > for exynos5440.  Also add basic dependencies for the PINCTRL_EXYNOS
> > kernel config.
> >
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> > ---
> > Changes in v3:
> > - Moved to chip level as per Tomasz.
> > - Update PINCTRL Kconfig for exynos.
> >
> > Changes in v2:
> > - Moved to the arch level as suggested by Olof.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org> for the pinctrl
> part, I guess this will be merged through the Samsung tree?
> 
Linus, thanks for your ack.

Let me take this into samsung tree.

- Kukjin

