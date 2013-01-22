Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3AVB1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 20:27:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57676 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3AVB1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 20:27:49 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-aa-50fdeb139a8b
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'amit kachhap'" <amit.kachhap@gmail.com>,
        "'Zhang Rui'" <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org, jonghwa3.lee@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Durgadoss'" <durgadoss.r@intel.com>
References: <1357517296-31402-1-git-send-email-amit.daniel@samsung.com>
 <1358321601.2252.36.camel@rzhang1-mobl4>
 <CADGdYn4CWscQf0y6dmgYUsKB8u25BOmLYq+T64haBKpwnZ3KBQ@mail.gmail.com>
In-reply-to: <CADGdYn4CWscQf0y6dmgYUsKB8u25BOmLYq+T64haBKpwnZ3KBQ@mail.gmail.com>
Subject: RE: [PATCH 1/2] thermal: sysfs: Add a new sysfs node emul_temp
Date: Mon, 21 Jan 2013 17:27:30 -0800
Message-id: <04ce01cdf83f$a7352b00$f59f8100$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKB50j123ZjViHYyJJFpr1ugh0hbwJyuXVyAjuG2vqWxz3e8A==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zfV3h138DDLYtNLG4vGsOm8Xn3iOM
	FjPO72NyYPb4vEkugDGKyyYlNSezLLVI3y6BK2PjmQWMBbe4Kiat38PUwLiPo4uRk0NCwERi
	1YndbBC2mMSFe+uBbC4OIYFljBJbu26zwxRdfnaJBSKxiFGiac0hVgjnL6PEqmN7WECq2AQ0
	JA6/fwbUwcEhIuAnMf93BEgNs8ACRolpS3ZDNexklLh54hAbSBGnQLBExyUfkF5hAXeJW9+e
	M4HYLAKqEvPPTWYFsXkFLCV+7JzFBmELSvyYfA9sF7OAlsTmbU2sELa8xOY1b5khLlWQ2HH2
	NSOILSLgJPFt5jc2iBpxiUkPHrKD3CAhsI1dYtOpC2wQywQkvk0+xAJyj4SArMSmA1BzJCUO
	rrjBMoFRYhaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiJOKkd
	jCsbLA4xCnAwKvHwWjz6GyDEmlhWXJl7iFGCg1lJhHdGFFCINyWxsiq1KD++qDQntfgQYzLQ
	sROZpUST84HJIK8k3tDY2MTMxNTE3NLU3JQ0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBxcEo1
	MPLXrEhVmhBXV+LxedHDFS8itzJcnHD8ieACzkLBJ/MPWYfcDF6RcyNE8ce50tnb5nydxaR6
	+EnWomkW+R16fMwl2srvex0OpsdN6NvOX2Dmd5upsyP70Yf1a8pedi3asYNp3zG7vtTN7VfX
	PM+NcTI4KaZz+dp/Xkm/nSJruQTXmvOf6lOb2KjEUpyRaKjFXFScCAB99m6V/AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAV3h138DDCb91be4vGsOm8Xn3iOM
	FjPO72NyYPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFj45kF
	jAW3uComrd/D1MC4j6OLkZNDQsBE4vKzSywQtpjEhXvr2boYuTiEBBYxSjStOcQK4fxllFh1
	bA9YFZuAhsTh98/Yuxg5OEQE/CTm/44AqWEWWMAoMW3JbqiGnYwSN08cYgMp4hQIlui45APS
	KyzgLnHr23MmEJtFQFVi/rnJrCA2r4ClxI+ds9ggbEGJH5Pvge1iFtCS2LytiRXClpfYvOYt
	M8SlChI7zr5mBLFFBJwkvs38xgZRIy4x6cFD9gmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5
	oDgpPddQrzgxt7g0L10vOT93EyM4np9J7WBc2WBxiFGAg1GJh9fi0d8AIdbEsuLK3EOMEhzM
	SiK8M6KAQrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTDV5JfGGxiZmRpZGZhZGJubmpAkr
	ifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoFx/kH/OVGV/2p3uizPmztvymIVy9SznDnbeKzv
	nJC5NtV10aql95hifVt0d3L8mSvGONPliKKLtEmjWU75r5hAX7sVLfFaYqe6QlmsFTf5vhZY
	2qu58+3+72zfPeU97qTu/F14IOlL7qrDD1fvYj44t7E1siqtbumZ9XcUzzb1sW0qX3VdyXC2
	EktxRqKhFnNRcSIAIRpUoSsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amit kachhap wrote:
> 
> Hi Rui,
> 
> Thanks for the review comments,
> On Tue, Jan 15, 2013 at 11:33 PM, Zhang Rui <rui.zhang@intel.com> wrote:
> > Hi, Amit,
> >
> > On Sun, 2013-01-06 at 16:08 -0800, Amit Daniel Kachhap wrote:
> >> This patch adds support to set the emulated temperature method in
> >> thermal zone (sensor). After setting this feature thermal zone must
> >> report this temperature and not the actual temperature. The actual
> >> implementation of this emulated temperature is based on sensor
> >> capability or platform specific. This is useful in debugging different
> >> temperature threshold and its associated cooling action. Writing 0 on
> >> this node should disable emulation.
> >
> > Question:
> > will this bring hardware issue? Say, critical temperature reached while
> > in emulation mode?
> No emulation does cause any h/w issue.
> >
> > As this is for debug purpose, I'd prefer to have a seperate Kconfig
> > option for this feature.
> Yes agreed. Will re-submit with kconfig option.
> >
> >> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Hi Zhang,

Once Amit addresses comments from you, I think, this looks good to Exynos
SoCs. And this is _really_ needed.

Feel free to add my ack on this 1st and 2nd patches:

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

