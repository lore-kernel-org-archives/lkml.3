Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaCaI4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:56:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:9258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbaCaI4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:56:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,763,1389772800"; 
   d="scan'208";a="510837286"
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
Subject: RE: [PATCH 21/55] scsi: Mark function as static in isci/port.c
Thread-Topic: [PATCH 21/55] scsi: Mark function as static in isci/port.c
Thread-Index: AQHPS3mV4rneoNKQaUG0IbsG9Cs6f5r65xeg
Date: Mon, 31 Mar 2014 08:56:30 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB208426C1@IRSMSX105.ger.corp.intel.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <1a67e2614c800cac379c183e4ff5a6b1eda34f9d.1396114898.git.rashika.kheria@gmail.com>
In-Reply-To: <1a67e2614c800cac379c183e4ff5a6b1eda34f9d.1396114898.git.rashika.kheria@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2V8ufQn025122

On Saturday, March 29, 2014 7:07 PM Rashika Kheria <rashika.kheria@gmail.com> wrote:
> Mark function as static in isci/port.c because they are not used outside
> this file.
> 
> This eliminates the following warning in isci/port.c:
> drivers/scsi/isci/port.c:65:13: warning: no previous prototype for
> â€˜port_state_nameâ€™ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>

> ---
>  drivers/scsi/isci/port.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
> index 13098b0..225d39f 100644
> --- a/drivers/scsi/isci/port.c
> +++ b/drivers/scsi/isci/port.c
> @@ -62,7 +62,7 @@
> 
>  #undef C
>  #define C(a) (#a)
> -const char *port_state_name(enum sci_port_states state)
> +static const char *port_state_name(enum sci_port_states state)
>  {
>  	static const char * const strings[] = PORT_STATES;
> 
> --
> 1.7.9.5

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
