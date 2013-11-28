Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab3K1Can (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:30:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12088 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3K1Cal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:30:41 -0500
X-AuditID: cbfee691-b7f666d0000048b0-d9-5296aad07037
From: Jingoo Han <jg1.han@samsung.com>
To: "'Jingoo Han'" <jg1.han@samsung.com>, "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>
References: <001c01ceebe1$825c5060$8714f120$%han@samsung.com>
In-reply-to: <001c01ceebe1$825c5060$8714f120$%han@samsung.com>
Subject: Re: [PATCH 1/9] mtd: amd76xrom: use DEFINE_PCI_DEVICE_TABLE macro
Date: Thu, 28 Nov 2013 11:30:39 +0900
Message-id: <001d01ceebe1$d4207930$7c616b90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7r4YIw6u9gU+jASR6kTGnc9PcE+QAABTIg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zfd0Lq6YFGTxewWdxeeElVov7X48y
	WlzeNYfN4nQ3qwOLx51re9g85p0M9OjbsorR4/MmuQCWKC6blNSczLLUIn27BK6MzU+WMBUs
	Zq7Y9/UYWwPjEaYuRk4OCQETia0HJjFD2GISF+6tZ+ti5OIQEljGKHF692xWmKK5PfsYIRLT
	GSU2rvoJ5fxilDiyaDc7SBWbgJrEly+HwWwRAS+Ju28ng61gFvCQ6D02BWgsB1CDrcSBVaEg
	YU4BO4n2O0fAyoWBypct3QB2BYuAqsSTfzPAbF6g8t0PbkDZghI/Jt9jgRipJbF+53Go8fIS
	m9e8ZQYZLyGgLvHory6IKSJgJNG8Sw2iQkRi34t3YBdLCBxjl/je9YwJYpWAxLfJh1ggWmUl
	Nh2AhoOkxMEVN1gmMErMQrJ4FpLFs5AsnoVkxQJGllWMoqkFyQXFSelFpnrFibnFpXnpesn5
	uZsYIfE4cQfj/QPWhxiTgdZPZJYSTc4HxnNeSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTBar6tZ+Keka97ElImRO9tDb3PYTGrjV7a8+9PlZf3e
	640TTr2eJ31wnvnhytbH9iveye6eNENy33+O7m21ttavue4aGU5LvrQxUuBzS1XZpVdvpt9Y
	vVdA6urhkyu27FG6m/lXjllBbf3Fo9Jt5W1ymo1tLX3Ky9MPmMm7z/SVUTq5P2A3I+siJZbi
	jERDLeai4kQAm1G6Ut0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd0Lq6YFGcx4ymVxeeElVov7X48y
	WlzeNYfN4nQ3qwOLx51re9g85p0M9OjbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl
	7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygjUoKZYk5pUChgMTiYiV9O0wTQkPcdC1g
	GiN0fUOC4HqMDNBAwjrGjM1PljAVLGau2Pf1GFsD4xGmLkZODgkBE4m5PfsYIWwxiQv31rN1
	MXJxCAlMZ5TYuOonI4Tzi1HiyKLd7CBVbAJqEl++HAazRQS8JO6+nQw2iVnAQ6L32BSgbg6g
	BluJA6tCQcKcAnYS7XeOgJULA5UvW7qBGcRmEVCVePJvBpjNC1S++8ENKFtQ4sfkeywQI7Uk
	1u88DjVeXmLzmrfMIOMlBNQlHv3VBTFFBIwkmnepQVSISOx78Y5xAqPQLCSDZiEZNAvJoFlI
	WhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI72Z9I7GFc1WBxiFOBgVOLhldCZFiTE
	mlhWXJl7iFGCg1lJhFehGCjEm5JYWZValB9fVJqTWnyIMRnoz4nMUqLJ+cBElFcSb2hsYmZk
	aWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjFr1Ta0LzkzgujdhzZKm+wcP
	MJccuWrWXTuhOyZmzr6ohVNNWP5s2hwhFScz2+VF771Pz/3fTVHXll33yfSrlsbBB7vmik+K
	f3bm+hRtiZ1+6a+v2dqcPVXvITK92231GY3TIXwtt/TEosx3P9nWsncGz7JHKufa/qY4NKtM
	m+6Y8mndUrG2E1xKLMUZiYZazEXFiQACFWa7OgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 28, 2013 11:28 AM, Jingoo Han wrote:
> This macro is used to create a struct pci_device_id array.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Oops,
Please ignore this patch.
I was confused, so I sent the patch to wrong cc-list.
Sorry.

Best regards,
Jingoo Han

> ---
>  drivers/mtd/maps/amd76xrom.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 


