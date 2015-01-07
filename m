Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbbAGPOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:14:23 -0500
Received: from smtp.citrix.com ([66.165.176.89]:48357 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbbAGPOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:14:22 -0500
X-IronPort-AV: E=Sophos;i="5.07,715,1413244800"; 
   d="scan'208";a="211927417"
Message-ID: <54AD4C62.6030301@citrix.com>
Date: Wed, 7 Jan 2015 15:10:26 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <konrad.wilk@oracle.com>, <jgross@suse.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] x86/xen: Free bootmem in free_p2m_page()
 during early boot
References: <1420639734-24808-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1420639734-24808-1-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/15 14:08, Boris Ostrovsky wrote:
> With recent changes in p2m we now have legitimate cases when
> p2m memory needs to be freed during early boot (i.e. before
> slab is initialized).
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Applied to to stable/for-linus-3.19, thanks.

If I understand correctly this didn't fully fix your 32-bit dom0 crashes?

David
