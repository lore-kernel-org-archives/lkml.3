Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab3BEFff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:35:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47000 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3BEFfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:35:31 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <511099D5.1020209@jp.fujitsu.com>
Date: Tue, 5 Feb 2013 14:34:13 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: liguang <lig.fnst@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <x86@kernel.org>, <rientjes@google.com>
Subject: Re: [PATCH v2 3/4] acpi: add clock_domain field to acpi_srat_cpu_affinity
References: <1360031838-26898-1-git-send-email-lig.fnst@cn.fujitsu.com> <1360031838-26898-4-git-send-email-lig.fnst@cn.fujitsu.com>
In-Reply-To: <1360031838-26898-4-git-send-email-lig.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/02/05 11:37, liguang wrote:
> according to ACPI SPEC v5.0, page 152,
> 5.2.16.1 Processor Local APIC/SAPIC Affinity Structure,
> the last member of it is clock_domain.
> 
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   include/acpi/actbl1.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
> index 280fc45..98031a3 100644
> --- a/include/acpi/actbl1.h
> +++ b/include/acpi/actbl1.h
> @@ -922,7 +922,7 @@ struct acpi_srat_cpu_affinity {
>   	u32 flags;
>   	u8 local_sapic_eid;
>   	u8 proximity_domain_hi[3];
> -	u32 reserved;		/* Reserved, must be zero */
> +	u32 clock_domain;
>   };
>   
>   /* Flags */
> 


