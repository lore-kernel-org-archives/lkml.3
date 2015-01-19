Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbbASRLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:11:53 -0500
Received: from smtp.citrix.com ([66.165.176.89]:7910 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbbASRLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:11:52 -0500
X-IronPort-AV: E=Sophos;i="5.09,428,1418083200"; 
   d="scan'208";a="218555456"
Message-ID: <54BD3AC8.1040808@citrix.com>
Date: Mon, 19 Jan 2015 17:11:36 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Ross Lagerwall <ross.lagerwall@citrix.com>,
        <xen-devel@lists.xenproject.org>
CC: <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH] xen/manage: Fix USB interaction issues when
 resuming
References: <1421673578-12127-1-git-send-email-ross.lagerwall@citrix.com>
In-Reply-To: <1421673578-12127-1-git-send-email-ross.lagerwall@citrix.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/01/15 13:19, Ross Lagerwall wrote:
> Commit 61a734d305e1 ("xen/manage: Always freeze/thaw processes when
> suspend/resuming") ensured that userspace processes were always frozen
> before suspending to reduce interaction issues when resuming devices.
> However, freeze_processes() does not freeze kernel threads.  Freeze
> kernel threads as well to prevent deadlocks with the khubd thread when
> resuming devices.
> 
> This is what native suspend and resume does.

Applied to stable/for-linus-3.19, thanks.

David

