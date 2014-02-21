Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaBUHUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 02:20:32 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25010 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaBUHUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 02:20:31 -0500
Date: Fri, 21 Feb 2014 10:20:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?utf-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v1.3 1/11] arcmsr: Revise interrupt service routine to
 fix command timeout
Message-ID: <20140221072001.GF26776@mwanda>
References: <CAKiknE9M44XvZQSjGRSgvgUHrgfbhwj8eTNRHWJ-VO+NU=cbvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKiknE9M44XvZQSjGRSgvgUHrgfbhwj8eTNRHWJ-VO+NU=cbvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 10:56:34AM +0800, 黃清隆 wrote:
> From: Ching <ching2048@areca.com.tw>
> 
> Rewrite interrupt service routine to fix command timeout on controller
> too heavy loading.
> 
> Singed-off-by: Ching <ching2048@areca.com.tw>

This email is still line wrapped I'm afraid.  It doesn't apply.

> ---
> 
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c
> b/drivers/scsi/arcmsr/arcmsr_attr.c
> --- a/drivers/scsi/arcmsr/arcmsr_attr.c 2014-02-07 01:47:24.000000000 +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_attr.c 2014-01-10 20:28:48.000000000 +0800
> -#define ARCMSR_SCSI_INITIATOR_ID
>          255
> +#define ARCMSR_SCSI_INITIATOR_ID       255

Please do white space changes in a separate change set so that the logic
changes are easier to review.

Use "git citool".  Highlight the lines with white space changes and then
right click and select "Stage lines for commit".  It is a very useful
tool.

regards,
dan carpenter
