Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab3CHMpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:45:14 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39555 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab3CHMpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:45:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: "Zheng, Lv" <lv.zheng@intel.com>, "lenb@kernel.org" <lenb@kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "mpm@selenic.com" <mpm@selenic.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "rob@landley.net" <rob@landley.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [RESEND PATCH 3/6] acpi: Remove the leading spaces of "finish_override" label in acpi_tb_table_override().
Date: Fri, 08 Mar 2013 13:52:06 +0100
Message-ID: <2886355.xlsA0q5tTx@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5139A494.2050500@cn.fujitsu.com>
References: <1362652697-30284-1-git-send-email-tangchen@cn.fujitsu.com> <1AE640813FDE7649BE1B193DEA596E88C197C2@SHSMSX101.ccr.corp.intel.com> <5139A494.2050500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 08, 2013 04:43:00 PM Tang Chen wrote:
> On 03/08/2013 04:28 PM, Zheng, Lv wrote:
> > Please do not try to fix ACPICA indentation problems in Linux side.
> > This will introduce source code divergences between ACPICA and Linux, which will add difficulties to ACPICA release work.
> > Please find real issues in ACPICA release scripts at:
> >
> > https://github.com/acpica/acpica/tree/master/generate/linux
> 
> Hi Lv,
> 
> Thanks for telling me this. :)
> 
> One more thing, if I want to fix something in acpica, such as this patch 
> set,
> who and which mail list should I send patches to ?

Please post them to linux-acpi@vger.kernel.org with CCs to me and Bob Moore.

Thanks,
Rafael


> >> -----Original Message-----
> >> From: Tang Chen [mailto:tangchen@cn.fujitsu.com]
> >> Sent: Thursday, March 07, 2013 6:38 PM
> >> To: lenb@kernel.org; rjw@sisk.pl; Moore, Robert; Zheng, Lv;
> >> ming.m.lin@intel.com; mpm@selenic.com; herbert@gondor.apana.org.au;
> >> rob@landley.net
> >> Cc: linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org;
> >> linux-doc@vger.kernel.org; trivial@kernel.org
> >> Subject: [RESEND PATCH 3/6] acpi: Remove the leading spaces of
> >> "finish_override" label in acpi_tb_table_override().
> >>
> >> There is 7 leading spaces in front of "finish_override" label in
> >> acpi_tb_table_override(). Remove them.
> >>
> >> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
> >> ---
> >>   drivers/acpi/acpica/tbinstal.c |    2 +-
> >>   1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/acpi/acpica/tbinstal.c b/drivers/acpi/acpica/tbinstal.c index
> >> e57cd38..b1e098d 100644
> >> --- a/drivers/acpi/acpica/tbinstal.c
> >> +++ b/drivers/acpi/acpica/tbinstal.c
> >> @@ -313,7 +313,7 @@ struct acpi_table_header
> >> *acpi_tb_table_override(struct acpi_table_header
> >>
> >>   	return (NULL);		/* There was no override */
> >>
> >> -      finish_override:
> >> +finish_override:
> >>
> >>   	ACPI_INFO((AE_INFO,
> >>   		   "%4.4s %p %s table override, new table: %p",
> >> --
> >> 1.7.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
