Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3ILKmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:42:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16221 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab3ILKmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:42:01 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-5d-52319a772278
From: Jingoo Han <jg1.han@samsung.com>
To: "'Michal Simek'" <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu
Cc: "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <7016a90750626ba866dddc6f85cfdd71943f6891.1378965270.git.michal.simek@xilinx.com>
 <f9868e54718ba467691085ff78061a447eef3635.1378965270.git.michal.simek@xilinx.com>
In-reply-to: <f9868e54718ba467691085ff78061a447eef3635.1378965270.git.michal.simek@xilinx.com>
Subject: Re: [PATCH 2/3] video: xilinxfb: Use devm_kzalloc instead of kzalloc
Date: Thu, 12 Sep 2013 19:42:00 +0900
Message-id: <000c01ceafa4$b6294b60$227be220$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vfNElQwIZa4AmRMGICEDWsAoR0QAJ3a6Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zI92KWYZBBptELS4vvMRqcaLvA6vF
	5V1z2CzevYywePLxNIvFuocvmCzWz7/F5sDu8erCHRaPv11TmD36tqxi9Dh+YzuTx+dNch57
	P/9mCWCL4rJJSc3JLEst0rdL4MrYOPcja8ExpopL06awNzC2MXUxcnJICJhIzDjdwA5hi0lc
	uLeerYuRi0NIYBmjxP6mW6xdjBxgRZM7ckFqhASmM0rMaDWEqPnFKNG68T0rSIJNQE3iy5fD
	YINEBOIkeg/sZAQpYhZYyyixZP4WRoiOzYwSs5+dYwOZyimQINF4PhakQVjAV+LyhGUsIDaL
	gKrEzhMrmUFsXgFbiQMTbrJB2IISPybfA6thFtCSWL/zOBOELS+xec1bZohD1SUe/dWFuMFI
	4ld7O1SJiMS+F+/ATpAQ+MousfDTF2aIXQIS3yYfYoHolZXYdIAZEhCSEgdX3GCZwCgxC8nm
	WUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihMTwxB2M9w9YH2JMBlo/
	kVlKNDkfmALySuINjc2MLExNTI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cCovlNpnR6XU8LckD7jjUZB3nuWiC/0rOV97DXXfMED5dkCRafkvx5vEJlyvpvV4aml
	iFVPiMvks2Jr9r+c69yq8u1ET1JJUlrLIsHKhXXhlQFsRm4Tfi19ILJilWuJ48x24TPrl9So
	sMxqysisMV23b83iw18PsVoVa1g52034oPrsU8butTOVWIozEg21mIuKEwHeuNj89wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t9jQd3yWYZBBnenWFpcXniJ1eJE3wdW
	i8u75rBZvHsZYfHk42kWi3UPXzBZrJ9/i82B3ePVhTssHn+7pjB79G1Zxehx/MZ2Jo/Pm+Q8
	9n7+zRLAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPj3I+sBceYKi5N
	m8LewNjG1MXIwSEhYCIxuSO3i5ETyBSTuHBvPRuILSQwnVFiRqthFyMXkP2LUaJ143tWkASb
	gJrEly+H2UFsEYE4id4DOxlBipgF1jJKLJm/hRGiYzOjxOxn59hANnAKJEg0no8FaRAW8JW4
	PGEZC4jNIqAqsfPESmYQm1fAVuLAhJtsELagxI/J98BqmAW0JNbvPM4EYctLbF7zlhniaHWJ
	R391IW4wkvjV3g5VIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgx
	t7g0L10vOT93EyM4RTyT2sG4ssHiEKMAB6MSD2/HLIMgIdbEsuLK3EOMEhzMSiK8nycaBgnx
	piRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjB95ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBI
	ID2xJDU7NbUgtQhmCxMHp1QDY8DW9XcDxFQWJE28/GnbW+WkSY7M13Te2B3b+lC8rPRJzMln
	+3h2Hm5cxlC95uXUT0eYr7XfWD+n7rzo3U+r7+3hTrrW9CDXTPfd8h1He5ZV2sdYNSbbOk7b
	m8BsbXOo+KqcS8+Twn8fU1ewHOY69Zov4D0z0EnXJlkE+TyZOy3vr/pBxezFN5VYijMSDbWY
	i4oTARJtQCZVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 12, 2013 2:55 PM, Michal Simek wrote:
> 
> Simplify driver probe and release function.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

> ---
>  drivers/video/xilinxfb.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)


