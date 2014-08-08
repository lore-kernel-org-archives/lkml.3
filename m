Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbaHHNlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:41:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23917 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaHHNlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:41:08 -0400
Date: Fri, 8 Aug 2014 16:39:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Panos Vlachos <panosvlchs@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:bcm:verndorspecificficextn.c: fixed five styling
 issues
Message-ID: <20140808133953.GK4856@mwanda>
References: <1407502092-18967-1-git-send-email-panosvlchs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407502092-18967-1-git-send-email-panosvlchs@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 03:48:12PM +0300, Panos Vlachos wrote:
> -INT vendorextnReadSection(PVOID  pContext, PUCHAR pBuffer, enum bcm_flash2x_section_val SectionVal,
> +INT vendorextnReadSection(PVOID  pContext, PUCHAR pBuffer,
> +	enum bcm_flash2x_section_val SectionVal,
>  			UINT offset, UINT numOfBytes)
        ^^              ^^

These are not lined up at all.

regards,
dan carpenter

