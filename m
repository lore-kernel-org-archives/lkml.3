Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3K2KrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:47:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48480 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3K2KrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:47:15 -0500
X-AuditID: cbfee690-b7f126d00000418c-6d-529870acac5a
Date: Fri, 29 Nov 2013 10:47:08 +0000 (GMT)
From: Rahul Jain <rahul.jain@samsung.com>
Subject: [Issue] Bridge Info Details with and without sysfs
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-net@vger.kernel.org" <linux-net@vger.kernel.org>
Cc: ASHWINI KUMAR <k.ashwini@samsung.com>
Reply-to: rahul.jain@samsung.com
MIME-version: 1.0
X-MTR: 20131129104423958@rahul.jain
Msgkey: 20131129104423958@rahul.jain
X-EPLocale: en_US.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131129103203563@rahul.jain
X-ParentMTR: 20131129103203563@rahul.jain
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <20751226.176781385722028701.JavaMail.weblogic@epml26>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42JZI2JSq7umYEaQwcYf5haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjb+NqxoJ38hVtx46zNTA2yHcxcnIICahK7Fm6lBnElhAwkfj5
	6ggLhC0mceHeerYuRi6gmqWMErvuzmSHKXp6fgkLRGI+o8SMgzeZQBIsQJOuzOhiBbHZBLQk
	Ht1uBYsLC1hLNO3dCdYsIlAjMf3iMbBtzALaEms3fGKGuEJBYvP972wgNq+AoMTJmU+grlCW
	uLkCxOYAiqtIfHhRDBEWl/jb8AjqHl6JGe1PocrlJKZ9XQP1jLTE+VkbGGGeWfz9MVScX+LY
	7R1MICNBep/cD4YZs3vzFzYIW0Bi6pmDjBAlGhKHJztChLUkTqxuYIeZsuvUcmaY1vtb5jJB
	PKUoMaX7ITtIK7OApsT6XfrofuIVcJK4uuYyywRG5VlIUrOQdM9C6EZWsoCRZRWjaGpBckFx
	UnqRiV5xYm5xaV66XnJ+7iZGYEI4/e/ZhB2M9w5YH2JMBkbHRGYp0eR8YELJK4k3NDYzsjA1
	MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGNg/+Rwf01jB5mh3u
	W5Jx5kHY/jeXNsm0/uOb/PQZj8jUx3HcX2fxXoxP5YqTO3w9uqb8i9OrhlcJaqZFcZfetHje
	bc1IFHltPa96wa5o9aBVonc39Ugce1vgwhkoWDH//z2JE7UqNx9X/Szi2aDRt4LrxYkNC34W
	ZDzcGVGVJW28/WKH9otaJZbijERDLeai4kQAU0g3/B4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsVy+t/t6bprCmYEGXzZo29xedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DE1jrQwNDIxMgWoS0jL+
	Nq5mLHgnX9F27DhbA2ODfBcjJ4eQgKrEnqVLmUFsCQETiafnl7BA2GISF+6tZ+ti5AKqmc8o
	MePgTSaQBAtQw5UZXawgNpuAlsSj261gcWEBa4mmvTvZQWwRgRqJ6RePgQ1lFtCWWLvhEzPE
	MgWJzfe/s4HYvAKCEidnPoFapixxcwWIzQEUV5H48KIYIiwu8bfhETuEzSsxo/0pVLmcxLSv
	a6BulpY4P2sDI8zNi78/horzSxy7vYMJZCRI75P7wTBjdm/+wgZhC0hMPXOQEaJEQ+LwZEeI
	sJbEidUN7DBTdp1azgzTen/LXCaIpxQlpnQ/ZAdpZRbQlFi/Sx/dT7wCThJX11xmmcAoNwtJ
	ahaS7lkI3chKFjCyrGIUTS1ILihOSq8w0StOzC0uzUvXS87P3cQITkvPluxgbLhgfYhRgINR
	iYc3oHN6kBBrYllxZe4hRgkOZiUR3mm5M4KEeFMSK6tSi/Lji0pzUosPMSYDI28is5Rocj4w
	ZeaVxBsam5ibGptaGBiam5uRJqwkzrvgVlKQkEB6YklqdmpqQWoRzBYmDk6pBsZXu9afi5Gf
	e3TlSn32qXP8a9wiTOwvVGgsqJihWhC/WCl4jsylko8te+5rXjZ8ecPg4xzOz1L9FR67t7Dc
	d9lo33pwfvzv6sx3q/494L+8u9hj+3yZliWBa3Mjszap1vW6vN94/nPPy9vLJ3oKX9X2cxKz
	mLe06OW6fZ7/U+wnP0z4e0CpmjVZiaU4I9FQi7moOBEAMu62MY8DAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rATAlfEk032338

Hi list,
While displaying bridge info using brctl command,  different results are observed with and without sysfs mounted.
Discrepancy
Bridge info results for following fields
    max age         bridge max age
    hello time      bridge hello time
    forward delay   bridge forward delay
are different.
Snapshot for both the cases
With Sysfs mounted,
-----------------------------------------------------------------------------------------------------------
brctl showstp virbr0
virbr0
 bridge id  8000.002454fb6fd3
 designated root 8000.002454fb6fd3
 root port     0   path cost     0
 max age    39.99   bridge max age    39.99
 hello time     1.99   bridge hello time    1.99
 forward delay  1999.69   bridge forward delay 1999.69
 ageing time   299.95
 hello timer     0.45   tcn timer     0.00
 topology change timer    0.00   gc timer  1996.15
 flags   

eth0.2 (0)
 port id  0000   state       forwarding
 designated root 8000.002454fb6fd3 path cost    19
 designated bridge 8000.002454fb6fd3 message age timer    0.00
 designated port 8001   forward delay timer    0.00
 designated cost    0   hold timer     0.00
 flags   
eth0.3 (0)
 port id  0000   state       forwarding
 designated root 8000.002454fb6fd3 path cost    19
 designated bridge 8000.002454fb6fd3 message age timer    0.00
 designated port 8002   forward delay timer    0.00
 designated cost    0   hold timer     0.00
 flags   
-----------------------------------------------------------------------------------------------------------
 
without sysfs (using ioctl),
-----------------------------------------------------------------------------------------------------------
sudo umount /sys
brctl showstp virbr0
virbr0
 bridge id  8000.002454fb6fd3
 designated root 8000.002454fb6fd3
 root port     0   path cost     0
 max age    39.99   bridge max age   400.00
 hello time     1.99   bridge hello time   20.00
 forward delay  20000.00   bridge forward delay 1999.69
 ageing time   299.95
 hello timer     0.10   tcn timer     0.00
 topology change timer    0.00   gc timer  1967.80
 flags   

eth0.2 (1)
 port id  8001   state       forwarding
 designated root 8000.002454fb6fd3 path cost    19
 designated bridge 8000.002454fb6fd3 message age timer    0.00
 designated port 8001   forward delay timer    0.00
 designated cost    0   hold timer     0.00
 flags   
eth0.3 (2)
 port id  8002   state       forwarding
 designated root 8000.002454fb6fd3 path cost    19
 designated bridge 8000.002454fb6fd3 message age timer    0.00
 designated port 8002   forward delay timer    0.00
 designated cost    0   hold timer     0.00
 flags  
-----------------------------------------------------------------------------------------------------------
 This looks to be an issue with either sys interface implementation or ioctl (BRCTL_GET_BRIDGE_INFO) implementation for getting the info?
 Any inputs are welcome.
 Thanks
-RahulˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
