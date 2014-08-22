Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbaHVNwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:52:49 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58151 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbaHVNws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:52:48 -0400
X-IronPort-AV: E=Sophos;i="5.04,380,1406592000"; 
   d="scan'208";a="164897617"
Message-ID: <53F74B29.4090601@citrix.com>
Date: Fri, 22 Aug 2014 14:52:41 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mukesh Rathor <mukesh.rathor@oracle.com>, <boris.ostrovsky@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [V0 PATCH 0/2] AMD PVH domU support
References: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
In-Reply-To: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/08/14 03:16, Mukesh Rathor wrote:
> Hi,
> 
> Here's first stab at AMD PVH domU support. Pretty much the only thing
> needed is EFER bits set. Please review.

I'm not going to accept this until there is some ABI documentation
stating explicitly what state non-boot CPUs will be in.

I'm particularly concerned that: a) there is a difference between AMD
and Intel; and b) you want to change the ABI by clearing a the EFER.SCE bit.

David
