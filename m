Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaABLoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:44:17 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:20454 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaABLoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:44:16 -0500
X-IronPort-AV: E=Sophos;i="4.95,590,1384300800"; 
   d="scan'208";a="87005408"
Message-ID: <52C5510E.1080503@citrix.com>
Date: Thu, 2 Jan 2014 11:44:14 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 17/18] xen/pvh/arm/arm64: Disable PV code that does
 not work with PVH (v2)
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-18-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-18-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> As we do not have yet a mechanism for that.
> 
> This also impacts the ARM/ARM64 code (which does not have
> hotplug support yet).

Subject needs to be "xen/pvh: disable VCPU hotplug with PVH" or similar
since it's only disabling this one feature.

David
