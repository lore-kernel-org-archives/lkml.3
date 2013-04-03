Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab3DCAjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 20:39:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35816 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3DCAjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 20:39:02 -0400
X-AuditID: cbfee690-b7f656d0000007e3-ba-515b7a24def3
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Richard Guy Briggs'" <rbriggs@redhat.com>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable] thermal: return an error on failure to register
 thermal
Date: Wed, 03 Apr 2013 09:38:55 +0900
Message-id: <000001ce3003$a1b87aa0$e5296fe0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJsw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zI12VquhAgyt3WS2WNHNbXN41h83i
	1s6TLBZPHvaxWSzY+IjRgdVj8Z6XTB7v911l8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	7fMusxXc4ax4tegmawNjD0cXIweHhICJxOadcl2MnECmmMSFe+vZuhi5OIQEljFKNLxZygyR
	MJHYufgSE0RiEaPExas72SGcv4wSUy5tZASpYhPQlTi2fgsriC0i4C1xasovsG5mgSyJ5vl/
	2UG2CQlwS6xuDgIJcwrwSKz70wlWIiwQKvG4ZyYTiM0ioCpxYeIesJG8AnYSL97OYoawBSV+
	TL7HAjFSS2L9zuNMELa8xOY1b5khnlGXePRXF+ICI4nlV5awQ5SISOx78Y4R5GQJgUvsErOn
	PWKF2CUg8W3yIRaIXlmJTQeg/pWUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4
	Kb3IRK84Mbe4NC9dLzk/dxMjJDYn7GC8d8D6EGMy0PqJzFKiyfnA2M4riTc0NjOyMDUxNTYy
	tzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6Nnzf+bzu9T2P9ySzJlXap6
	mHsoclmTNt+FwvsawlUpqvGv7x/7zWwgKDYh8YPYw90u3KIZjnJVOjNV+6T2cbTZH87MuMXo
	t4btevCln30ZnOL8l4VcrW92NKvedjxxOuRs4lGnnh+PPnf8Psp13HN3Jze70QR3Uc8Qmbvn
	pHZ8dDw4n1fmthJLcUaioRZzUXEiAJuu6TjjAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jAV2VquhAgwkJFkuauS0u75rDZnFr
	50kWiycP+9gsFmx8xOjA6rF4z0smj/f7rrJ59G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5K
	Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr4dpgmh
	IW66FjCNEbq+IUFwPUYGaCBhHWPG9nmX2QrucFa8WnSTtYGxh6OLkZNDQsBEYufiS0wQtpjE
	hXvr2boYuTiEBBYxSly8upMdwvnLKDHl0kZGkCo2AV2JY+u3sILYIgLeEqem/GIGsZkFsiSa
	5/8FauAAauCWWN0cBBLmFOCRWPenE6xEWCBU4nHPTLBlLAKqEhcm7gEbyStgJ/Hi7SxmCFtQ
	4sfkeywQI7Uk1u88zgRhy0tsXvOWGWS8hIC6xKO/uhAXGEksv7KEHaJERGLfi3eMExiFZiGZ
	NAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDkP5PewbiqweIQowAH
	oxIP74kvUYFCrIllxZW5hxglOJiVRHhPh0UHCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+
	MCnllcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjwE2GG9u8
	PAWjdGSXvjMVtIuboFOn2u2pUyLFb3Y7Ue+FpHOU6H6eU1uaHj5nqC47lTX37C6eltZPPzeH
	xtz7fjK8qE112j//L50WGimlf7dzGz3kWfP3uUnOCleWe9zX3r9QKlFNs3PsdglSCgkNPteo
	qbbaTGHOj9vLMgymvbzPME/nXaMSS3FGoqEWc1FxIgCmsh7LQAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Richard Guy Briggs <rbriggs@redhat.com>"

commit da28d966f6aa942ae836d09729f76a1647932309 upstream.

The return code from the registration of the thermal class is used to
unallocate resources, but this failure isn't passed back to the caller of
thermal_init.  Return this failure back to the caller.

This bug was introduced in changeset 4cb18728 which overwrote the return
code
when the variable was re-used to catch the return code of the registration
of
the genetlink thermal socket family.

Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/thermal_sys.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 6472e7e..1a19a2f 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1875,6 +1875,7 @@ static int __init thermal_init(void)
 		idr_destroy(&thermal_cdev_idr);
 		mutex_destroy(&thermal_idr_lock);
 		mutex_destroy(&thermal_list_lock);
+		return result;
 	}
 	result = genetlink_init();
 	return result;
-- 
1.7.9.5

