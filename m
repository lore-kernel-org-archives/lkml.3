Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3KKTye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:54:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab3KKTyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:54:21 -0500
Date: Mon, 11 Nov 2013 20:56:05 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 00/29] Introduce pcim_enable_msi*() family helpers
Message-ID: <20131111195604.GB9679@dhcp-26-207.brq.redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 07:12:00PM +0200, Alexander Gordeev wrote:
> Patches 1,2	- ACK'ed tweaks for s390 architecture
> Patches 3,4	- fixes for PowerPC pSeries platform
> Patches 5-12	- fixes, tweaks and changes of the generic MSI code
> Patches 12-29	- example updates of few device drivers

Hi Bjorn,

There was not negative feedback so far - can we go ahead with patches
1,2 and 5-12? Would be nice to have patches 3,4 reviewed, but they are
not really a blocker.

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
