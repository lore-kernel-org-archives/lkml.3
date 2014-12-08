Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaLHJVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:21:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40564 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaLHJVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:21:15 -0500
X-AuditID: cbfee68e-f79b46d000002b74-fa-54856d898e33
From: Inha Song <ideal.song@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, ckeepax@opensource.wolonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel][PATCH 0/2] mfd: arizona: Add support for OUTn_MONO
 register control
Date: Mon, 08 Dec 2014 18:20:20 +0900
Message-id: <1418030422-27061-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkSLcztzXE4O0PeYupD5+wWfzZd5zR
	Yv6Rc6wW/W8Wslrs+nuf0eLcq5WMFve/HmW0uLxrDpvF0usXmSyWv/3PZjFh+loWi9a9R9gt
	TnezOvB6rJm3htHjcl8vk8fK5V/YPDat6mTzuHNtD5vHvJOBHi8n/gYK7fnN7NG3ZRWjx+dN
	cgFcUVw2Kak5mWWpRfp2CVwZm+4fZyk4xFJx5/Fb9gbG08xdjJwcEgImEis/7mCEsMUkLtxb
	z9bFyMUhJLCUUeJHzxtGmKLrl56yQyQWMUrcewvjzGGSWNp9jxWkik1AQ+L7581AYzk4RAR0
	JK7fSAepYRbYxSSx+f0dsHXCAtESLzctBatnEVCVeNMxgR3E5hVwk1i8qZEVYpu2xL6GmWBn
	SAicY5fYv2odO0SDgMS3yYdYQBZICMhKbDoA9YKkxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSk
	V5yYW1yal66XnJ+7iREYI6f/PevbwXjzgPUhRgEORiUe3gUPWkKEWBPLiitzDzGaAm2YyCwl
	mpwPjMS8knhDYzMjC1MTU2Mjc0szJXHeBKmfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY
	1X52H3LKS+7lE/I8Nc0zaQPbxI9FN15unvZ8q8ShjiVHwpmXvqh9cvPLz4PXfpU6P/NuqJ6w
	ImLKJ+H6X/arXi49tbHyZl2p/7w9yqsma23bKVb9xVss/duFRi2ft4on13tavI881fWt7q1x
	OmPOtIXP1moEbo7U4+DOlDY70nM3uf/9k8Y8eyWW4oxEQy3mouJEAN/kfX2MAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t9jAd3O3NYQgy/nxC2mPnzCZvFn33FG
	i/lHzrFa9L9ZyGqx6+99Rotzr1YyWtz/epTR4vKuOWwWS69fZLJY/vY/m8WE6WtZLFr3HmG3
	ON3N6sDrsWbeGkaPy329TB4rl39h89i0qpPN4861PWwe804Geryc+BsotOc3s0ffllWMHp83
	yQVwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA
	Ha+kUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzNh0/zhLwSGWijuP37I3
	MJ5m7mLk5JAQMJG4fukpO4QtJnHh3nq2LkYuDiGBRYwS996CJECcOUwSS7vvsYJUsQloSHz/
	vBmom4NDREBH4vqNdJAaZoFdTBKb398BmyosEC3xctNSsHoWAVWJNx0TwDbwCrhJLN7UyAqx
	TVtiX8NMtgmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEfgM+kdjKsaLA4xCnAw
	KvHwLnzQEiLEmlhWXJl7iFGCg1lJhDcxrjVEiDclsbIqtSg/vqg0J7X4EKMp0PaJzFKiyfnA
	5JBXEm9obGJmZGlkbmhhZGyuJM5742ZuiJBAemJJanZqakFqEUwfEwenVAPjBpa6c7nmnyuW
	npxtK/l1zsvK2hrbguvXbSr+/7p3NUqK+VvKFeF6k9SgIkb2Eyvn9yXX63Ks5OBt57035euN
	wxr6vzvaRTS2qhj+SJDeaZsl92/a7Aj/LSc2rrv3V2jVs+DGf9c27dWeOW0Hk+TmZTf+GSUv
	kv3w7u9TecfbKr6HWIyNZggpK7EUZyQaajEXFScCADu3uXrWAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add support for OUTn_MONO register control using platform data.
Each output signal can be configurated as a mono differential output.
The mono differential configuration is selected using the OUTn_MONO registers.

Inha Song (2):
  mfd: arizona: Add support for OUTn_MONO register control
  mfd: arizona: Update DT binding to support OUTn_MONO init_data

 Documentation/devicetree/bindings/mfd/arizona.txt |  7 +++++++
 drivers/mfd/arizona-core.c                        | 10 ++++++++++
 2 files changed, 17 insertions(+)

-- 
2.0.0.390.gcb682f8

