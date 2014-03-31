Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaCaI6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:58:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:53813 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbaCaI57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:57:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,763,1389772800"; 
   d="scan'208";a="483845576"
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: intel-linux-scu <intel-linux-scu@intel.com>,
        "Patelczyk, Maciej" <maciej.patelczyk@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
Subject: RE: [PATCH 20/55] scsi: Mark function as static in
 isci/remote_device.c
Thread-Topic: [PATCH 20/55] scsi: Mark function as static in
 isci/remote_device.c
Thread-Index: AQHPS3lt/VwtsWvWbU+bI8BL53Il9pr65tPw
Date: Mon, 31 Mar 2014 08:55:41 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB208426AE@IRSMSX105.ger.corp.intel.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <ba8bc6c22f1d7949f8a727dfef4262c1336b8a71.1396114898.git.rashika.kheria@gmail.com>
In-Reply-To: <ba8bc6c22f1d7949f8a727dfef4262c1336b8a71.1396114898.git.rashika.kheria@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2V8w9Hb025133

On Saturday, March 29, 2014 7:05 PM Rashika Kheria <rashika.kheria@gmail.com> wrote:
> Mark function as static in isci/remote_device.c because it is not used
> outside this file.
> 
> This eliminates the following warning in isci/remote_device.c:
> drivers/scsi/isci/remote_device.c:1387:6: warning: no previous prototype for
> â€˜isci_remote_device_wait_for_resume_from_abortâ€™ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>

> ---
>  drivers/scsi/isci/remote_device.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
> index 96a26f4..33033fb 100644
> --- a/drivers/scsi/isci/remote_device.c
> +++ b/drivers/scsi/isci/remote_device.c
> @@ -1384,7 +1384,7 @@ static bool isci_remote_device_test_resume_done(
>  	return done;
>  }
> 
> -void isci_remote_device_wait_for_resume_from_abort(
> +static void isci_remote_device_wait_for_resume_from_abort(
>  	struct isci_host *ihost,
>  	struct isci_remote_device *idev)
>  {
> --
> 1.7.9.5

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
