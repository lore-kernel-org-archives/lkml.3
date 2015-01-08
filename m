Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbbAHOov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:44:51 -0500
Received: from smtp.citrix.com ([66.165.176.89]:31348 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbbAHOou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:44:50 -0500
X-IronPort-AV: E=Sophos;i="5.07,723,1413244800"; 
   d="scan'208";a="212680787"
Message-ID: <54AE97BC.1040909@citrix.com>
Date: Thu, 8 Jan 2015 14:44:12 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <konrad.wilk@oracle.com>, <jgross@suse.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v2] x86/xen: Free bootmem in free_p2m_page()
 during early boot
References: <1420655263-17239-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1420655263-17239-1-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/15 18:27, Boris Ostrovsky wrote:
> With recent changes in p2m we now have legitimate cases when
> p2m memory needs to be freed during early boot (i.e. before
> slab is initialized).
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Reviewed-by: Juergen Gross <jgross@suse.com>
> ---
> 
> v2: Add __ref annotation

Thanks.  I've updated stable/for-linus-3.19 with this version.

David
