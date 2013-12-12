Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab3LLJM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:12:29 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11479 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3LLJMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:12:21 -0500
X-AuditID: cbfee68e-b7fee6d000003b32-a1-52a97df379dd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Gregory CLEMENT'" <gregory.clement@free-electrons.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc: "'Kuninori Morimoto'" <kuninori.morimoto.gx@renesas.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'Jason Cooper'" <jason@lakedaemon.net>,
        "'Simon Horman'" <horms@verge.net.au>, linux-sh@vger.kernel.org,
        "'Magnus Damm'" <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        "'Valentine Barshak'" <valentine.barshak@cogentembedded.com>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        linux-tegra@vger.kernel.org, "'Shawn Guo'" <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20131211183237.GI4699@google.com>
 <52A96877.90902@free-electrons.com>
In-reply-to: <52A96877.90902@free-electrons.com>
Subject: Re: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada,
 R-Car PCI host maintainers
Date: Thu, 12 Dec 2013 18:12:18 +0900
Message-id: <001901cef71a$41f3a520$c5daef60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac73DX8jLZm4Pdk4TvC/NyRJkE9DYwADBrSQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0hTcRjG/Z9zdnZB6bRm/RMvYTcyvM2p/24WWHBCMDUtskKnHZykUzaV
	IKqpZWgkiYoxVCxnlobKLHAac05sSdZSyxJyeC/FRTQVDS9tO1/82rcf7/M8PO8LLw8XGjge
	vHR5DqOQSzN8SQHxfmNW7G+79SIuqP4LH2kKZGjOeAhpi6wAFb5eAihfM0yg4SdDHDTf2wmQ
	dmqEg4Y7q0n0odZEosdmPYaq1ypwVLyoJtF4s5VEMy0aHK121hJoZrwAQ42Wfgz9HurDka6l
	mHtKRI9XbmL0tHYQ0Dr1GJeu0+bSKoOZoL+PvCHpds0denmgjKBLXzUBusHSB+jq1WWCtmm9
	Y1wTBcevMRnpeYwiMCJZIHv3cJLMHuDeWG4wcVWggCwBPB6kJPB+T24J4NtxJ/xkabWPBTwh
	9QzAB4VzGCtI4PB8OWCFKgDbiyaBQxBSfwFsG/NyMEkdgIuLvVwHi6jb0FS5gjkCOFXDgZub
	XVw2EA8bVB1O5lNBcGq2g3DwDuoqtKoWSAcT1H5Yc7ff6XGjTsCaug2M5e1wpdzi9OOUH2zV
	mTCWfWD7SyvOXnMQTq77O1BEiWHr9E3WIYL6n7+c+0NqkwfrxwYJtoqCy+VGgo16Qa0BZ+/d
	DXuefyMeAajeUqzeUqzeUqzeUlEHiCbgzmSnZitT0hTiAKU0U5krTwtIzcrUAvZ7SjvAqOGY
	EaTa68twD/fULPt3yXOSgkPCxChUEhoiDj8S9n9j311uTydS4oRUmjSHuc4w2YwiSZGbwSiN
	AOPxPVTgtLDRM1/mWZXQeC4tVp9cVZH1J9a8Mhi9V1989mO0OjjRZSHs4gWXNe0VLziTaZs4
	GclPclV294YnMFWXz/cdTVn6cVhzL9rUIVTL3nZ9DXT/fIl8HBWcZz5j2xPhA5Xr9d0TOo73
	lFuBJLKtMH10pF1kbo5diY/aB7ZJrDEVvoRSJg32wxVK6T8RACyQUwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsVy+t9jQd3PtSuDDDZOYrZY0pRh8fKQpsWm
	treMFs1bvzJaNC65zGJxeeElVotXh3cxWmx6fI3V4vKuOWwWZ+cdZ7OYcX4fk8WcP1OYLTq/
	zGKzeLD6LZvF03VLmC1+7prHYvH0QROTxfJ7J5ksPlw6ymyxc10nu4OIx4Op/5k8nmy6yOix
	c9Zddo8Fm0o9Gg6cZ/G4c20Pm8fmJfUe385MZPHo27KK0WPpvaOMHnN+fmPx+LxJLoAnqoHR
	JiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoTyWFssSc
	UqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxoneR2wFZ9grvi09zt7A2MTWxcjJ
	ISFgInH51WRGCFtM4sK99UBxLg4hgemMEpvbHoElhAR+MUpsuCsLYrMJqEl8+XKYHcQWEaiT
	OD71BxNIA7PAXFaJ//93s0M0hEgsbdgBZnMKGEg8fraDBcQWFoiVeNvwBmwzi4CqxNyWk2A1
	vAK2EnMX/GOCsAUlfky+B1bPLKAlsX7ncSYIW15i85q3zF2MHECXqks8+qsLYooIGEmsf1IN
	USEise/FO8YJjEKzkAyahWTQLCSDZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMj
	OLU9k97BuKrB4hCjAAejEg/vi4MrgoRYE8uKK3MPMUpwMCuJ8LqkrgwS4k1JrKxKLcqPLyrN
	SS0+xJgM9OdEZinR5Hxg2s0riTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoR
	zBYmDk6pBsaFzUmX9mUs+VUTmL3QSHa/yZO30ifmzo3nObsl3izXxSyUaY6E9feXZ+a9kvnP
	G6mcyNW/QrrapJ3ZZGn54m2W70zO7Co9xD1b/oqQ3lmH9L9rhC/X7CouZmEoPhdmolCg/v/e
	5X1b9p6aZugdscPp3Ve32QVZSj0tN6+4n7xez3Rklwvf/hwlluKMREMt5qLiRABVPO3psQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 12, 2013 4:41 PM, Gregory CLEMENT wrote:
> On 11/12/2013 19:32, Bjorn Helgaas wrote:
> > If this looks reasonable, I'll merge it via the PCI tree for v3.13.
> >
> > Bjorn

[.....]

> > +PCI DRIVER FOR MVEBU (Marvell Armada 370 and Armada XP SOC support)
> > +M:	Jason Cooper <jason@lakedaemon.net>
> > +L:	linux-pci@vger.kernel.org
> > +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > +S:	Maintained
> > +F:	drivers/pci/host/*mvebu*
> 
> I think that Thomas Petazzoni would be more appropriate, he worked
> on the mvebu PCIe since 6 moths and now know very well the
> subject. Until now all the mvebu PCIe related questions were
> managed by Thomas.

I think so, too. :-)

Thomas Petazzoni is the author of the  mvebu PCIe. Also, he did
The basic foundation of PCIe Host with Thierry Reding.  I think
That he is the best person for the Maintainer of the mvebu PCIe.

Best regards,
Jingoo Han

