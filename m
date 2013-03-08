Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923Ab3CHI3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 03:29:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:58527 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab3CHI3U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 03:29:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,806,1355126400"; 
   d="scan'208";a="301604751"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Tang Chen <tangchen@cn.fujitsu.com>, "lenb@kernel.org" <lenb@kernel.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "Moore, Robert" <robert.moore@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "mpm@selenic.com" <mpm@selenic.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "rob@landley.net" <rob@landley.net>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: RE: [RESEND PATCH 3/6] acpi: Remove the leading spaces of
 "finish_override" label in acpi_tb_table_override().
Thread-Topic: [RESEND PATCH 3/6] acpi: Remove the leading spaces of
 "finish_override" label in acpi_tb_table_override().
Thread-Index: AQHOGx+uhqV0TnLvn0S4gj706kJWvZibdsmQ
Date: Fri, 8 Mar 2013 08:28:21 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88C197C2@SHSMSX101.ccr.corp.intel.com>
References: <1362652697-30284-1-git-send-email-tangchen@cn.fujitsu.com>
 <1362652697-30284-4-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1362652697-30284-4-git-send-email-tangchen@cn.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please do not try to fix ACPICA indentation problems in Linux side.
This will introduce source code divergences between ACPICA and Linux, which will add difficulties to ACPICA release work.
Please find real issues in ACPICA release scripts at:

https://github.com/acpica/acpica/tree/master/generate/linux

Thanks
-Lv

> -----Original Message-----
> From: Tang Chen [mailto:tangchen@cn.fujitsu.com]
> Sent: Thursday, March 07, 2013 6:38 PM
> To: lenb@kernel.org; rjw@sisk.pl; Moore, Robert; Zheng, Lv;
> ming.m.lin@intel.com; mpm@selenic.com; herbert@gondor.apana.org.au;
> rob@landley.net
> Cc: linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-doc@vger.kernel.org; trivial@kernel.org
> Subject: [RESEND PATCH 3/6] acpi: Remove the leading spaces of
> "finish_override" label in acpi_tb_table_override().
> 
> There is 7 leading spaces in front of "finish_override" label in
> acpi_tb_table_override(). Remove them.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  drivers/acpi/acpica/tbinstal.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/tbinstal.c b/drivers/acpi/acpica/tbinstal.c index
> e57cd38..b1e098d 100644
> --- a/drivers/acpi/acpica/tbinstal.c
> +++ b/drivers/acpi/acpica/tbinstal.c
> @@ -313,7 +313,7 @@ struct acpi_table_header
> *acpi_tb_table_override(struct acpi_table_header
> 
>  	return (NULL);		/* There was no override */
> 
> -      finish_override:
> +finish_override:
> 
>  	ACPI_INFO((AE_INFO,
>  		   "%4.4s %p %s table override, new table: %p",
> --
> 1.7.1

