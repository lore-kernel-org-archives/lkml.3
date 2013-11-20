Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab3KTQIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:08:04 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:64764 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3KTQIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:08:02 -0500
Date: Wed, 20 Nov 2013 11:07:57 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 07/29] PCI/MSI: Return -ENOSYS for unimplemented
 interfaces, not -1
Message-ID: <20131120160757.GG28946@htj.dyndns.org>
References: <cover.1382103786.git.agordeev@redhat.com>
 <de85dc2f3aa27ff883504bd30d3f5f929145fe0d.1382103786.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de85dc2f3aa27ff883504bd30d3f5f929145fe0d.1382103786.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 07:12:07PM +0200, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Suggested-by: Ben Hutchings <bhutchings@solarflare.com>

Yes, please.

 Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
