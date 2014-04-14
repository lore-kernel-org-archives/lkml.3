Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaDNT2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:28:32 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:40218 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaDNT2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:28:30 -0400
Date: Mon, 14 Apr 2014 21:28:24 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Randy Dunlap <rdunlap@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: Re: [PATCH] s390: fix new ccwgroup.h kernel-doc warning
In-Reply-To: <534C1DC9.7020108@infradead.org>
Message-ID: <alpine.LFD.2.11.1404142127070.1561@denkbrett>
References: <534C1DC9.7020108@infradead.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041419-6892-0000-0000-000008776D7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix new s390 kernel-doc warning:
> 
> Warning(arch/s390/include/asm/ccwgroup.h:27): No description found for parameter 'ungroup_work'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc:	Sebastian Ott <sebott@linux.vnet.ibm.com>
> Cc:	Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> Cc:	linux-s390@vger.kernel.org
> Cc:	Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc:	Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc:	linux390@de.ibm.com
> ---
>  arch/s390/include/asm/ccwgroup.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- lnx-315-rc1.orig/arch/s390/include/asm/ccwgroup.h
> +++ lnx-315-rc1/arch/s390/include/asm/ccwgroup.h
> @@ -10,6 +10,8 @@ struct ccw_driver;
>   * @count: number of attached slave devices
>   * @dev: embedded device structure
>   * @cdev: variable number of slave devices, allocated as needed
> + * @ungroup_work: work to be done when a ccwgroup notifier has action
> + *	type %BUS_NOTIFY_UNBIND_DRIVER
>   */
>  struct ccwgroup_device {
>  	enum {
> 
> 

Applied, thanks!
Sebastian

