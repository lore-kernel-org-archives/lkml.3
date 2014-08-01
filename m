Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbaHAPaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:30:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:53421 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHAPaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:30:07 -0400
X-IronPort-AV: E=Sophos;i="5.01,780,1400025600"; 
   d="scan'208";a="158503477"
Message-ID: <53DBB27D.2040203@citrix.com>
Date: Fri, 1 Aug 2014 16:30:05 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <gregkh@linuxfoundation.org>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v5] Fixes to Xen pciback for 3.17.
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/07/14 17:18, Konrad Rzeszutek Wilk wrote:
> Greg: goto GHK
> 
> This is v5 version of patches to fix some issues in Xen PCIback.

Applied to devel/for-linus-3.17.

I dropped the stable Cc for #2 pending a final decision on whether it
really is a stable candidate.

David
