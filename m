Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaGINFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:05:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:34533 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaGINF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:05:28 -0400
X-IronPort-AV: E=Sophos;i="5.01,631,1400025600"; 
   d="scan'208";a="151222594"
Message-ID: <53BD3DF9.4020407@citrix.com>
Date: Wed, 9 Jul 2014 14:04:57 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <konrad@kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v3 6/7] xen/pciback: Print out the domain owning the device.
References: <1404845909-13563-1-git-send-email-konrad@kernel.org> <1404845909-13563-7-git-send-email-konrad@kernel.org>
In-Reply-To: <1404845909-13563-7-git-send-email-konrad@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/14 19:58, konrad@kernel.org wrote:
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> We had been printing it only if the device was built with
> debug enabled. But this information is usuable in the field
> to troubleshoot.

"useful"

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
