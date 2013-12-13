Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab3LMOa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:30:26 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:65059 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3LMOaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:30:23 -0500
X-IronPort-AV: E=Sophos;i="4.95,479,1384300800"; 
   d="scan'208";a="81998866"
Message-ID: <52AB19FB.10408@citrix.com>
Date: Fri, 13 Dec 2013 14:30:19 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <george.dunlap@eu.citrix.com>, <ian.jackson@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <tim@xen.org>, <jbeulich@suse.com>,
        <boris.ostrovsky@oracle.com>, Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH V10 09/14] xen: implement updated XENMEM_add_to_physmap_range
 ABI
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com> <1386900621-27528-10-git-send-email-konrad.wilk@oracle.com> <52AAF100.2020002@citrix.com> <20131213142746.GE2923@phenom.dumpdata.com>
In-Reply-To: <20131213142746.GE2923@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/13 14:27, Konrad Rzeszutek Wilk wrote:
> On Fri, Dec 13, 2013 at 11:35:28AM +0000, David Vrabel wrote:
>> On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
>>> From: Ian Campbell <Ian.Campbell@citrix.com>
>>>
>>> Allows for more fine grained error reporting. Only used by PVH and
>>> ARM both of which are marked EXPERIMENTAL precisely because the ABI
>>> is not yet stable
>>
>> This should be folded into patch 7.
> 
> In "07/14] xen/x86: remove duplicated include from enlighten.c" ?

Sorry. I meant:

[06/14] xen: x86 pvh: use XENMEM_add_to_physmap_range for foreign gmfn
mappings

I stopped calling out places where patches should be folded/refactored
at this point.

David
