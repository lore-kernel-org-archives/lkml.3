Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaJBOko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:40:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37802 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaJBOkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:40:42 -0400
X-AuditID: cbfee61a-f79c06d000004e71-96-542d63e8fdc0
Date: Thu, 02 Oct 2014 16:40:35 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] thermal: fix: Various fixes for thermal subsystem
Message-id: <20141002164035.1133b66f@amdc2363>
In-reply-to: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAd0XybohBp//S1hsnLGe1WL+lWus
	Fm8ecVu8ebiZ0eLyrjlsFp97jzBaPHnYx+bA7rFz1l12j8V7XjJ5rJv2ltmjb8sqRo/Pm+QC
	WKO4bFJSczLLUov07RK4Mu5PNys4ylqxsm03awPjQpYuRk4OCQETiTer1zNB2GISF+6tZ+ti
	5OIQEljEKHHqz24mCOcXo8TzpxdYQapYBFQlFh//B2azCehJfL77FKiIg0NEwFtiyxoOkHpm
	gVuMEv/23GMBiQsLeEmsXikDUs4LVP7hSA87iM0p4C5x8/czMFtIwE3i4K+DYDa/gKRE+78f
	zBAH2Umc+7SBHaJXUOLH5HtgRzMLaEls3tbECmHLS2xe85Z5AqPgLCRls5CUzUJStoCReRWj
	aGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcOA/k9rBuLLB4hCjAAejEg9vRoNOiBBrYllxZe4h
	RgkOZiURXr0o3RAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwc
	nFINjLnsG7OeN9zP/ORuI5DNtuVHT2DkVGYtUe439b/mcRmxf52bfibiRt/1tjt5q9tceaIN
	ntebXmbk2/r9rMa9tJORnNvUnpT4Xep8vjgk8dBHV53unR2cZrMP7cpvT5rNHvG8/NOiHhmL
	PbZ3nEr8k5OeX53xlyN5csDNA057mn78fmjN+icsV4mlOCPRUIu5qDgRAFlgy/V4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eduardo, Zhang,

> This little patch series comprises fixes for step_wise governor and
> thermal core.
> 
> Lukasz Majewski (3):
>   thermal: step_wise: fix: Prevent from binary overflow when trend is
>     dropping
>   thermal: core: fix: Initialize the max_state variable to 0
>   thermal: core: fix: Check return code of the ->get_max_state()
>     callback
> 

ping.

Please note, that those are rather self explanatory fixes.

>  drivers/thermal/step_wise.c    | 2 +-
>  drivers/thermal/thermal_core.c | 8 +++++---
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
