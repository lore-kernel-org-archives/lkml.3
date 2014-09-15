Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaIOPbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:31:21 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:54972 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaIOPbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:31:19 -0400
X-IronPort-AV: E=Sophos;i="5.04,529,1406592000"; 
   d="scan'208";a="172430830"
Message-ID: <5417063C.9070204@citrix.com>
Date: Mon, 15 Sep 2014 16:31:08 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <mukesh.rathor@oracle.com>
CC: <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 0/4] drivers/xen/xenbus/xenbus_client.c: Several
 improvements for it
References: <54157282.40402@gmail.com>
In-Reply-To: <54157282.40402@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/14 11:48, Chen Gang wrote:
> They are all for 'xenbus_client.c', please help check when you have time,
> thanks.
> 
> Chen Gang (4):
>   drivers/xen/xenbus/xenbus_client.c: Remove redundancy assignment to 'addr'
>   drivers/xen/xenbus/xenbus_client.c: Correct the comments for xenbus_grant_ring()
>   drivers/xen/xenbus/xenbus_client.c: Remove BUG_ON() when error string trucated
>   drivers/xen/xenbus/xenbus_client.c: Improve the failure processing for __xenbus_switch_state()

The prefix should be the subsystem not the file (files move around).
i.e., xen/xenbus.

David
