Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3LMLEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:04:34 -0500
Received: from smtp.citrix.com ([66.165.176.89]:42983 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3LMLEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:04:33 -0500
X-IronPort-AV: E=Sophos;i="4.95,478,1384300800"; 
   d="scan'208";a="84231702"
Message-ID: <52AAE9BD.9060305@citrix.com>
Date: Fri, 13 Dec 2013 11:04:29 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <george.dunlap@eu.citrix.com>, <ian.jackson@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <tim@xen.org>, <jbeulich@suse.com>,
        <boris.ostrovsky@oracle.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH V10 08/14] x86/xen: Use __pa_symbol instead of __pa on
 C visible symbols
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com> <1386900621-27528-9-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386900621-27528-9-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
> From: Alexander Duyck <alexander.h.duyck@intel.com>
> 
> This change updates a few of the functions to use __pa_symbol when
> translating C visible symbols instead of __pa.  By using __pa_symbol we are
> able to drop a few extra lines of code as don't have to test to see if the
> virtual pointer is a part of the kernel text or just standard virtual memory.

Why is this part of the PVH series?

David
