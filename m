Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaH1OI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:08:28 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:23743 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaH1OI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:08:27 -0400
X-IronPort-AV: E=Sophos;i="5.04,418,1406592000"; 
   d="scan'208";a="166782338"
Message-ID: <53FF37D8.8070509@citrix.com>
Date: Thu, 28 Aug 2014 15:08:24 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mukesh Rathor <mukesh.rathor@oracle.com>, <boris.ostrovsky@oracle.com>,
        <david.vrabel@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V1 PATCH 0/2] Linux PVH: set EFER bits..
References: <1409178815-2026-1-git-send-email-mukesh.rathor@oracle.com>
In-Reply-To: <1409178815-2026-1-git-send-email-mukesh.rathor@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/14 23:33, Mukesh Rathor wrote:
> Resending with comments fixed up. Please note, these are no longer
> AMD only, but address existing broken boot and broken NX on intel.

It's no secret that I'm fed up with the cavalier attitude to the PVH ABI.

The Xen change that broke Linux PVH guests must be reverted.  This
change may also have broken other guests (e.g., Mirage or one of the
other unikernel OSes).

The documented posted by Roger is a good start, but I'm still not going
to apply any PVH patches to Linux until the ABI is agreed and stable and
the document is committed to the Xen repo.

David
