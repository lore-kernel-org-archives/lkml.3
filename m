Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaKCS0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:26:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33840 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaKCS0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:26:50 -0500
Message-ID: <5457C904.8070203@oracle.com>
Date: Mon, 03 Nov 2014 10:27:16 -0800
From: "santosh.shilimkar@oralce.com" <santosh.shilimkar@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>, Santosh Shilimkar <ssantosh@kernel.org>
CC: Sandeep Nair <sandeep_n@ti.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] soc: ti: knav_qmss_queue: Use list_for_each_entry_safe
 to prevent use after free
References: <1414819993.23500.1.camel@phoenix>
In-Reply-To: <1414819993.23500.1.camel@phoenix>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 10:33 PM, Axel Lin wrote:
> list_for_each_entry_safe() is necessary if list objects are deleted from
> the list while traversing it.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---

Right. Picked up for 3.19. Thanks !!

Regards,
Santosh
