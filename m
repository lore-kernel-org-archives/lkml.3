Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaL3Lq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 06:46:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34632 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaL3Lq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 06:46:26 -0500
X-AuditID: cbfee68f-f791c6d000004834-3c-54a2909030aa
Date: Tue, 30 Dec 2014 20:46:24 +0900
From: Inha Song <ideal.song@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, ckeepax@opensource.wolfsonmicro.com,
        lee.jones@linaro.org
Subject: Re: [alsa-devel] [PATCH] mfd: wm8994: use PLATFORM_DEVID_AUTO for
 regulator devs creation to avoid conflicts
Message-id: <20141230204624.7fb94518@songinha-Samsung-DeskTop-System>
In-reply-to: <20141230112821.GL11764@sirena.org.uk>
References: <1419918320-12693-1-git-send-email-ideal.song@samsung.com>
 <20141230112821.GL11764@sirena.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsWyRsSkUHfChEUhBg+naFtcuXiIyWLqwyds
	Fv+m3GC3uP/1KKPFtysdTBaXd81hs1j+9j+bxeluVgcOjw2fm9g8ds66y+6xaVUnm8eda3vY
	POadDPR4OfE3m8fnTXIB7FFcNimpOZllqUX6dglcGb+/lBT8Y6s4fmAFYwPjadYuRk4OCQET
	idnTNzFB2GISF+6tZ+ti5OIQEljKKPFmwg5GmKLrrx4zQySmM0rsvDgFyulnkvh8fDFYO4uA
	qkTH9SPMIDabgIbE98+bwWwRAWWJq9/3soA0MAucZZR4vWU5WEJYoFxiUn87O4jNK+AqsWXb
	NTYQm1PAWKLj/AqwGiGBfInNPT+hbrWRWL1zHTNEvaDEj8n3WEBsZgEtic3bmlghbHmJzWve
	gl0nIXCPXWLhVIgrWAQEJL5NPgTUwAGUkJXYdIAZYqakxMEVN1gmMIrNQjJ2FpKxs5CMXcDI
	vIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjMCZP/3vWv4Px7gHrQ4wCHIxKPLwb3i8MEWJN
	LCuuzD3EaAp0xURmKdHkfGDk55XEGxqbGVmYmpgaG5lbmimJ8y6U+hksJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgVHpckTNtrN9BY/mhyhsCv6csLRbYUMu+z7FMpfO7cWMW6c6hyqxFvg3
	Phe2OW6YaFktbvJs3vsFT83O/rJ/o+DHH/0loTOA43RmvfTa1UbOAXu/TRQ6VvTk2p1jxtzT
	7c+c2nLswp2Y/e3padc+LFRtWid+i/1BeughZX+3l3vXKz9QMNpSu0uJpTgj0VCLuag4EQBO
	T5d6xAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQd0JExaFGKxZoWJx5eIhJoupD5+w
	WfybcoPd4v7Xo4wW3650MFlc3jWHzWL52/9sFqe7WR04PDZ8bmLz2DnrLrvHplWdbB53ru1h
	85h3MtDj5cTfbB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynk
	Jeam2iq5+AToumXmAB2lpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcz4
	/aWk4B9bxfEDKxgbGE+zdjFyckgImEhcf/WYGcIWk7hwbz1bFyMXh5DAdEaJnRenMEM4/UwS
	n48vZgKpYhFQlei4fgSsg01AQ+L7581gtoiAssTV73tZQBqYBc4ySrzeshwsISxQLjGpv50d
	xOYVcJXYsu0aG4jNKWAs0XF+BViNkEC+xOaen1An2Uis3rmOGaJeUOLH5HssIDazgJbE5m1N
	rBC2vMTmNW+ZJzAKzEJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEf8
	M+kdjKsaLA4xCnAwKvHwbni/MESINbGsuDL3EKMEB7OSCG+jwaIQId6UxMqq1KL8+KLSnNTi
	Q4ymwOCYyCwlmpwPTEZ5JfGGxiZmRpZG5oYWRsbmSuK8SvZtIUIC6YklqdmpqQWpRTB9TByc
	Ug2MzSXz93Ql1XLJxeQEX2nMnXOgsqPaZX2PebfF6r3qoQ77gry/qSyS3qGa8mSmruj5it2T
	973od9ServX9UKbJoVf+86uZz3u+nChmqTSpQVfw1o3bdrvtvyx/+ClP2ZDdeWrcpfX5e1ht
	S8U7Dmut2nrZ5YrmjPa7RzI9/8vUz/RYd3TDQRsNJZbijERDLeai4kQAo2ClSA4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
Thanks for your reply.

Sure, Understand. I missed that part.

I will just fix id base to 0 from -1.
If not, duplicate filename error was reported like this.
- sysfs: cannot create duplicate filename '/devices/.../wm8994-ldo'

Best Regards,
Inha Song.

On Tue, 30 Dec 2014 11:28:21 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Tue, Dec 30, 2014 at 02:45:20PM +0900, Inha Song wrote:
> > After commit: 6e3f62f0793e ("mfd: core: Fix platform-device id generation")
> > We must set the id base when register a duplicate name of mfd_cell.
> > but, if we use PLATFORM_DEVID_AUTO flag, cell ids are automatically
> > allocated and managed without cell id setting.
> 
> The driver relies on getting those specific IDs in order to work out
> which LDO it's working with, automatically generated numbers may be the
> same now but can you guarantee that in future?
