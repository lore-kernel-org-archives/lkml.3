Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaKYSr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:47:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43041 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaKYSr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:47:26 -0500
Message-ID: <5474CF68.2020807@oracle.com>
Date: Tue, 25 Nov 2014 13:50:16 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        Borislav Petkov <bp@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
References: <20141119205150.700188369@linuxfoundation.org> <20141119205153.916605840@linuxfoundation.org> <5474C67A.7040200@oracle.com> <20141125184501.GA3461@kroah.com>
In-Reply-To: <20141125184501.GA3461@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 01:45 PM, Greg Kroah-Hartman wrote:
> On Tue, Nov 25, 2014 at 01:12:10PM -0500, Boris Ostrovsky wrote:
>> On 11/19/2014 03:52 PM, Greg Kroah-Hartman wrote:
>>> 3.17-stable review patch.  If anyone has any objections, please let me know.
>>
>> This breaks PV on Xen.
> Does that mean it is also broken in Linus's tree?  If so, please fix it
> there.  If not, is there some other patch I am missing for 3.17-stable
> to resolve this?

Yes, it is broken in Linus's tree. That's the only tree that I tested 
and before we have a fix I wanted to avoid for this to trickle into 
stable trees as well (although I may be late).

-boris
