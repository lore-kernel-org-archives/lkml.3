Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab3KULUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:20:04 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:48604 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3KULUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:20:02 -0500
X-IronPort-AV: E=Sophos;i="4.93,743,1378857600"; 
   d="scan'208";a="74288241"
Message-ID: <528DEC5C.6080300@citrix.com>
Date: Thu, 21 Nov 2013 11:19:56 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Matt Wilson <msw@linux.com>
CC: <xen-devel@lists.xenproject.org>, Matt Wilson <msw@amazon.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Anthony Liguori <aliguori@amazon.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/gnttab: leave lazy MMU mode in the case of a m2p
 override failure
References: <1384978295-18292-1-git-send-email-msw@linux.com>
In-Reply-To: <1384978295-18292-1-git-send-email-msw@linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/11/13 20:11, Matt Wilson wrote:
> From: Matt Wilson <msw@amazon.com>
> 
> Commit f62805f1 introduced a bug where lazy MMU mode isn't exited if a
> m2p_add/remove_override call fails.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Should be tagged for stable.

David
