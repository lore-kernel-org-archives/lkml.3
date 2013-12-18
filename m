Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3LRNwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:52:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49702 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3LRNwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:52:19 -0500
Message-ID: <52B1A867.60808@oracle.com>
Date: Wed, 18 Dec 2013 21:51:35 +0800
From: Vaughan Cao <vaughan.cao@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: Steffen Maier <maier@linux.vnet.ibm.com>, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de> <525BE8C1.5090606@linux.vnet.ibm.com> <525BEF2B.2030907@suse.de> <525BF256.6060707@suse.de> <525C0CAE.3030803@linux.vnet.ibm.com> <525E37CA.2000605@suse.de> <5264C48A.80900@oracle.com>
In-Reply-To: <5264C48A.80900@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013年10月21日 14:07, vaughan wrote:
> On 10/16/2013 02:52 PM, Hannes Reinecke wrote:
>> But seeing that this approach raises quite some issues I've attached a
>> different patch. Vaughan, could you test with that, too? Should be
>> functionally equivalent to the previous one. Cheers, Hannes
> Hi Hannes,
>
> We only tested the later patch which returns _TARGET_PRESENT after
> parsing sense, it works as expected.
>
Hi Hannes,

Will your second patch be included in mainline?

Thanks,
Vaughan
