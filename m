Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaI3Jzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:55:31 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:52195 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaI3Jza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:55:30 -0400
X-IronPort-AV: E=Sophos;i="5.04,625,1406592000"; 
   d="scan'208";a="177480658"
Message-ID: <542A7E0E.9050702@citrix.com>
Date: Tue, 30 Sep 2014 10:55:26 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, <konrad.wilk@oracle.com>,
        <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <boris.ostrovsky@oracle.com>, <bhelgaas@google.com>, <jgross@suse.com>,
        <yongjun_wei@trendmicro.com.cn>, <mukesh.rathor@oracle.com>
CC: <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/xenbus: Use 'void' instead of 'int' for the return
 of xenbus_switch_state()
References: <5425961A.5000604@gmail.com>
In-Reply-To: <5425961A.5000604@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/14 17:36, Chen Gang wrote:
> When xenbus_switch_state() fails, it will call xenbus_switch_fatal()
> internally, so need not return any status value, then use 'void' instead
> of 'int' for xenbus_switch_state() and __xenbus_switch_state().
> 
> Also need be sure that all callers which check the return value must let
> 'err' be 0.
> 
> And also need change the related comments for xenbus_switch_state().

Since this patch does not fix a bug and there is no unanimous agreement
on the API change I'm not going to apply it (nor the previous version).

David

