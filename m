Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3JCEhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:37:19 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:33754 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab3JCEg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:36:59 -0400
Date: Wed, 2 Oct 2013 22:36:47 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ashley D Lai <adlai@linux.vnet.ibm.com>
Cc: Peter H?we <PeterHuewe@gmx.de>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net, Sirrix AG <tpmdd@sirrix.com>,
        Teddy Reed <teddy@prosauce.org>
Subject: Re: [tpmdd-devel] [PATCH 02/13] tpm atmel: Call request_region
 with the correct base
Message-ID: <20131003043647.GA1463@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1379960083-8942-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <201310020000.13490.PeterHuewe@gmx.de>
 <1380759074.20801.12.camel@buffalo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380759074.20801.12.camel@buffalo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 07:11:14PM -0500, Ashley D Lai wrote:

> > I somewhat have the feeling that we should maybe begin to deprecate
> > the vendor specific 1.1 tpms...

> I agree. If we have a machine to test and it fails then we know we don't
> have a user for this.

Is this driver is only used on IBM systems? If so, will IBM provide
support for those systems on RHEL7? If not the driver can probably
safely be dropped.

The trouble with these old drivers is that they don't follow modern
conventions (there are several little bugs at least) and nobody can
test them to safely fix them.

If you do find hardware, we can at least take a solid run at sprucing
up the testable drivers which should give them more life..

Jason
