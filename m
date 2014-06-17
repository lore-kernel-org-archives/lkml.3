Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965550AbaFQQeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:34:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:54226 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933617AbaFQQ0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:26:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,495,1400050800"; 
   d="scan'208";a="549282075"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Anil Belur <askb23@gmail.com>, "Drokin, Oleg" <oleg.drokin@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpdd-discuss@lists.01.org" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH v6 8/8] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
Thread-Topic: [PATCH v6 8/8] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
Thread-Index: AQHPie/WqEyUws9dhEm2zoqLWACo5Zt1jp0A
Date: Tue, 17 Jun 2014 16:25:14 +0000
Message-ID: <CFC5C7D5.ABDC7%andreas.dilger@intel.com>
References: <1402983839-3549-1-git-send-email-askb23@gmail.com>
 <1402983839-3549-9-git-send-email-askb23@gmail.com>
In-Reply-To: <1402983839-3549-9-git-send-email-askb23@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.132.85]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BE39DEC9FAB4B442AFE04D7D191C61A4@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/06/16, 11:43 PM, "Anil Belur" <askb23@gmail.com> wrote:

>From: Anil Belur <askb23@gmail.com>
>
>fixed: WARNING: suspect code indent for conditional statements (32, 32)
>Signed-off-by: Anil Belur <askb23@gmail.com>
>---
> drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
>b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
>index e2da397..3b2b995 100644
>--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
>+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
>@@ -825,8 +825,8 @@ int ccc_prep_size(const struct lu_env *env, struct
>cl_object *obj,
> 				loff_t size_index = ((size - 1) >> PAGE_CACHE_SHIFT);
> 
> 				if ((size == 0 && cur_index != 0) ||
>-				    (size_index < cur_index))
>-				*exceed = 1;
>+						(size_index < cur_index))

The old indentation of this line (aligned after '(' on the previous line)
was better.  Note also that there is no need for parenthesis around this
statement.

>+					*exceed = 1;
> 			}
> 			return result;
> 		} else {
>-- 
>1.9.0
>
>


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


