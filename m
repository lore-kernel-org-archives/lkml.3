Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbaD2IFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:05:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53495 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbaD2IFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:05:46 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-c9-535f5d59826c
Message-id: <535F5D58.8000007@samsung.com>
Date: Tue, 29 Apr 2014 17:05:44 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: Robert Baldyga <r.baldyga@samsung.com>, sameo@linux.intel.com,
        a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com
Subject: Re: [PATCH v2 1/2] mfd: max77693: remove unnecessary wrapper functions
References: <1398750527-20715-1-git-send-email-r.baldyga@samsung.com>
 <1398750527-20715-2-git-send-email-r.baldyga@samsung.com>
 <20140429075202.GA29462@lee--X1>
In-reply-to: <20140429075202.GA29462@lee--X1>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsWyRsSkUDcyNj7Y4FiPgMWSi1fZLV6/MLS4
	//Uoo8XlXXPYLNYeuctu8eDwTnaL/Z0djBanu1kdODz2TDzJ5nHn2h42j3knAz36tqxi9Jg+
	7yeTx+dNcgFsUVw2Kak5mWWpRfp2CVwZW9YuYi74yl4x6fZP1gbGBWxdjJwcEgImEtvf3GaB
	sMUkLtxbDxTn4hASWMoo8ebIQWaYoqU7pjBDJBYxSpxf95AFwnnNKDHh5CegDAcHr4CWxJ/D
	7iANLAKqEq8vTmUEsdmAwvtf3ADbJioQJrFy+hWwbbwCghI/Jt9jAWkVEVCROPfGHGQks8AJ
	Rolvb7vB6oUF/CW6Du0As4UEljBKXP4RD2JzCuhKHFv8GGwOs4C6xKR5i5ghbHmJzWvegh0q
	IXCPXeLWp/2sEAcJSHybfAhsmYSArMSmA1CPSUocXHGDZQKj2CwkJ81CMnYWkrELGJlXMYqm
	FiQXFCelFxnpFSfmFpfmpesl5+duYgRG4el/z/p2MN48YH2IMRlo5URmKdHkfGAU55XEGxqb
	GVmYmpgaG5lbmpEmrCTOu+hhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxnbz5TzZ/v7f
	Um4ssDzoaZ9ilpF6epdrWeTpOYbeSofnOMfac3wI+yOS+Y8n+9P3zCfXamUaXmxI8X+7e1fm
	6fLVFb2PVY7vzrXIXDwzfZPtjj6vsr6z0h2cT623qFvKO9TLbejh5I19ZMp/tbm8j81qvpat
	kSuDUe/XaqH7n6bb5tacsJ6nxFKckWioxVxUnAgA/W/PTNgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jAd3I2Phgg9nbOSyWXLzKbvH6haHF
	/a9HGS0u75rDZrH2yF12iweHd7Jb7O/sYLQ43c3qwOGxZ+JJNo871/awecw7GejRt2UVo8f0
	eT+ZPD5vkgtgi2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLx
	CdB1y8wBOkdJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLFl7SLmgq/s
	FZNu/2RtYFzA1sXIySEhYCKxdMcUZghbTOLCvfVAcS4OIYFFjBLn1z1kgXBeM0pMOPkJqIqD
	g1dAS+LPYXeQBhYBVYnXF6cygthsQOH9L26ADRUVCJNYOf0KC4jNKyAo8WPyPRaQVhEBFYlz
	b8xBRjILnGCU+Pa2G6xeWMBfouvQDjBbSGAJo8TlH/EgNqeArsSxxY/B5jALqEtMmreIGcKW
	l9i85i3zBEaBWUhWzEJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwTH+THoH
	46oGi0OMAhyMSjy8HTFxwUKsiWXFlbmHGCU4mJVEePOt4oOFeFMSK6tSi/Lji0pzUosPMSYD
	Q2Ais5Rocj4w/eSVxBsam5gZWRqZG1oYGZuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	A2NQhPeb7QezXn42/XxFaO+bDPm9qZmbNgZM+bL/fBmL/QP1+6Wi93wnplZm+D9I1D/y1EBA
	hXHirBerMxb75XcbK8+XO+3qL9V8oIpDXfvijB8Tg6Yt+nv94p8Sfmep9rnqlyuWRFr1iTz7
	0j0t2+RHVty3LoOKk57c6y7cWtBZcdty0XrZg/uVWIozEg21mIuKEwHKFYpdNQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 04:52 PM, Lee Jones wrote:
>> This patch removes wrapper functions used to access regmap, and
>> make driver using regmap_*() functions instead.
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> ---
>>  drivers/extcon/extcon-max77693.c     | 32 ++++++++++-----------
>>  drivers/mfd/max77693-irq.c           | 50 +++++++++++++++++++-------------
>>  drivers/mfd/max77693.c               | 56 ++----------------------------------
>>  drivers/regulator/max77693.c         | 12 ++++----
>>  include/linux/mfd/max77693-private.h |  8 ------
>>  5 files changed, 54 insertions(+), 104 deletions(-)
> 
> Bye bye abstraction for the sake for abstraction. Works for me!
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> Chanwoo,
>   I can add this to ib-mfd-extcon-3.16 with your Ack if you like.
>   That should make things somewhat easier.
> 

OK,

For extcon part about patch[1-2].
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi




