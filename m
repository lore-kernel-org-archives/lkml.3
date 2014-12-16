Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaLPAg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:36:59 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:60196 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaLPAgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:36:53 -0500
Date: Mon, 15 Dec 2014 16:36:48 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: Re: [PATCH 1/2] powercap/rapl: add ids for future xeon cpus
Message-ID: <20141216003648.GA32627@roeck-us.net>
References: <1418667255-8804-1-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418667255-8804-1-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A010204.548F7EA5.0068,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:14:15AM -0800, Jacob Pan wrote:
> Enable RAPL driver on Xeon cpu id 0x56.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/powercap/intel_rapl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
> index c71443c..ee00ffb 100644
> --- a/drivers/powercap/intel_rapl.c
> +++ b/drivers/powercap/intel_rapl.c
> @@ -1041,6 +1041,7 @@ static const struct x86_cpu_id rapl_ids[] = {
>  	RAPL_CPU(0x45, rapl_defaults_core),/* Haswell ULT */
>  	RAPL_CPU(0x4C, rapl_defaults_atom),/* Braswell */
>  	RAPL_CPU(0x4A, rapl_defaults_atom),/* Tangier */
> +	RAPL_CPU(0x56, rapl_defaults_atom),/* Future Xeon */

Is rapl_defaults_atom correct, or should this be rapl_defaults_core ?

Guenter

>  	RAPL_CPU(0x5A, rapl_defaults_atom),/* Annidale */
>  	{}
>  };
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
