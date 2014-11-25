Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaKYT0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:26:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46891 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaKYT0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:26:01 -0500
Message-ID: <5474D86E.6020608@oracle.com>
Date: Tue, 25 Nov 2014 14:28:46 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
References: <20141119205150.700188369@linuxfoundation.org> <20141119205153.916605840@linuxfoundation.org> <5474C67A.7040200@oracle.com> <20141125182410.GB4128@pd.tnic> <5474CDCE.6040000@oracle.com> <20141125184351.GC4128@pd.tnic> <5474D0A1.2020600@oracle.com> <20141125190849.GF4128@pd.tnic>
In-Reply-To: <20141125190849.GF4128@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 02:08 PM, Borislav Petkov wrote:
> On Tue, Nov 25, 2014 at 01:55:29PM -0500, Boris Ostrovsky wrote:
>> On 11/25/2014 01:43 PM, Borislav Petkov wrote:
>>> On Tue, Nov 25, 2014 at 01:43:26PM -0500, Boris Ostrovsky wrote:
>>>> I don't think this routine is called on PV.
>>> They're either both called or none is. At least on baremetal, that is.
>>>
>> PV guests don't start with startup_32.
>>
>> We are coming from a resume into load_ucode_ap as:
> Btw, why is this thing even running on xen? I'd like to make
> CONFIG_MICROCODE depend on !PARAVIRT and be done with it.

You'd have to decide at runtime --- many baremetal systems are compiled 
with PARAVIRT.

-boris

