Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaGIGd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:33:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59430 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaGIGdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:33:23 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-ce-53bce231d26d
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Christoph Hellwig'" <hch@infradead.org>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Luk?? Czerner'" <lczerner@redhat.com>,
        "'Brian Foster'" <bfoster@redhat.com>,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>, xfs@oss.sgi.com
References: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
 <20140708121500.GA518@infradead.org>
In-reply-to: <20140708121500.GA518@infradead.org>
Subject: RE: [PATCH 2/3] xfs: Add support IOC_MOV_DATA ioctl
Date: Wed, 09 Jul 2014 15:33:21 +0900
Message-id: <001801cf9b3f$ad786ff0$08694fd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJH64km/LFjhKi9hcuiYREqQxtdmwKGaWSgmpJZKsA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWyRsSkUNfw0Z5gg3kvVC2WTrzEbPHuc5XF
	lmP3GC1OT1jEZLHswWYWi5nz7rBZ7Nl7ksXi8q45bBatPT/ZLRb13WJ04PI4tUjCY/MKLY+m
	M0eZPVZf2Mro8X7fVTaPvi2rGD0+b5ILYI/isklJzcksSy3St0vgyni57QBzwRWWimedS1kb
	GJ8xdzFyckgImEgc2bqcCcIWk7hwbz1bFyMXh5DAUkaJxntbmWCKbh8+xgSRWMQoceDMV2YI
	5y+jxIfPL1m7GDk42AS0Jf5sEQVpEAEy1y87BraBWeAAk8TjxzYgtpBAgsS2iydYQWxOAUOJ
	bbcOsYPYwgI2Ejenv2UEsVkEVCXuPjjIAjKSV8BS4vrFdJAwr4CgxI/J91ggRmpJrN95nAnC
	lpfYvOYt1DMKEjvOvmaEOMFKouPbY6gTRCT2vXjHCHKyhEAnh8Sm1u3MELsEJL5NPgS2S0JA
	VmLTAag5khIHV9xgmcAoMQvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCelF5nqFSfmFpfmpesl
	5+duYgRG+ul/zybuYLx/wPoQYzLQ+onMUqLJ+cBEkVcSb2hsZmRhamJqbGRuaUaasJI4b/qj
	pCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjNYXOWJ1vt2T9RKpqvBjvW/2KTU6Y4+bftPL
	9cHX7ePdLi15JWj3U+Fi97STVhdMGSR6S9kecBtX/P3xkHv7DmvtNOeX9udMrPn0Tho1rco0
	vuKw+P7VCUdCr2kqzbhbzeRUmv0g+WvZi/DKG8n93/KPeup+uc5tdnXBhNUsibMSXu/aLcWQ
	rcRSnJFoqMVcVJwIAAAmWIcKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAV3DR3uCDU5dkbdYOvESs8W7z1UW
	W47dY7Q4PWERk8WyB5tZLGbOu8NmsWfvSRaLy7vmsFm09vxkt1jUd4vRgcvj1CIJj80rtDya
	zhxl9lh9YSujx/t9V9k8+rasYvT4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhDWPGy20HmAuusFQ861zK2sD4jLmLkZNDQsBE4vbhY0wQtpjEhXvr2boYuTiEBBYx
	Shw485UZwvnLKPHh80vWLkYODjYBbYk/W0RBGkSAzPXLjoENYhY4wCTx+LENiC0kkCCx7eIJ
	VhCbU8BQYtutQ+wgtrCAjcTN6W8ZQWwWAVWJuw8OsoCM5BWwlLh+MR0kzCsgKPFj8j0WiJFa
	Eut3HmeCsOUlNq95C3WzgsSOs68ZIU6wkuj49hjqBBGJfS/eMU5gFJqFZNQsJKNmIRk1C0nL
	AkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBaeSZ9A7GVQ0WhxgFOBiVeHgVePYEC7Em
	lhVX5h5ilOBgVhLh/eYGFOJNSaysSi3Kjy8qzUktPsRoCvToRGYp0eR8YIrLK4k3NDYxM7I0
	Mje0MDI2VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAmJrqK3x1lRD/nenJHBfLpkyOOP9o
	otZ+yR9zQp490GSrmMKmH9GQ0Htuv0PearcFRwrEpvidf8ZY+n2TkoKA2nkF0w95DQb5Rz8e
	lf4X16z/t+P5hemyz/w/NQrc9bvozHKk61nfz4mfLm4VCbp4v+cylxrPlhM3U1bcPB6QyZzT
	/f7y1W91q5RYijMSDbWYi4oTASl1BME5AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Tue, Jul 08, 2014 at 08:59:49PM +0900, Namjae Jeon wrote:
> > This patch implements fs ioctl's IOC_MOV_DATA for XFS.
> 
> Shouldn't this share code with the XFS_IOC_SWAPEXT implementation?
Lukas has raised the same question for ext4.
Both xfs(XFS_IOC_SWAPEXT) and ext4(EXT4_IOC_MOVE_EXT) has ioctls which uses
almost similar kind of structure as struct mov_data.
As such, there seems to be possiblity for sharing basic code (I will try)
used for sanity checking in IOC_MOV_DATA to be shared with these ioctls
but the core functionality code will remain different.

Thanks!

