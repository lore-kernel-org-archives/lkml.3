Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab3JDRVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:21:47 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46102 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3JDRVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:21:46 -0400
Message-ID: <524EF921.8030806@linux.vnet.ibm.com>
Date: Fri, 04 Oct 2013 12:21:37 -0500
From: Joel Schopp <jschopp@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ashley D Lai <adlai@linux.vnet.ibm.com>
CC: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net, Peter H?we <PeterHuewe@gmx.de>,
        Sirrix AG <tpmdd@sirrix.com>, Teddy Reed <teddy@prosauce.org>
Subject: Re: [tpmdd-devel] [PATCH 02/13] tpm atmel: Call request_region with
 the correct base
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com> <1379960083-8942-3-git-send-email-jgunthorpe@obsidianresearch.com> <201310020000.13490.PeterHuewe@gmx.de>	<1380759074.20801.12.camel@buffalo> <20131003043647.GA1463@obsidianresearch.com>
In-Reply-To: <20131003043647.GA1463@obsidianresearch.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100417-9332-0000-0000-000001A68C5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 11:36 PM, Jason Gunthorpe wrote:
> On Wed, Oct 02, 2013 at 07:11:14PM -0500, Ashley D Lai wrote:
> 
>>> I somewhat have the feeling that we should maybe begin to deprecate
>>> the vendor specific 1.1 tpms...
> 
>> I agree. If we have a machine to test and it fails then we know we don't
>> have a user for this.
> 
> Is this driver is only used on IBM systems? If so, will IBM provide
> support for those systems on RHEL7? If not the driver can probably
> safely be dropped.
> 
> The trouble with these old drivers is that they don't follow modern
> conventions (there are several little bugs at least) and nobody can
> test them to safely fix them.
> 
> If you do find hardware, we can at least take a solid run at sprucing
> up the testable drivers which should give them more life..
> 
> Jason

We don't have any plans to support 1.1 tpms in any new major
distribution releases.  I am in support of deprecating 1.1 tpms and just
supporting 1.2 and 2.0 going forward.

This is the direction we are taking with TrouSerS as well for what it's
worth.  So that's at least one major user you won't see complain about
missing tpm 1.1 support.

-Joel

