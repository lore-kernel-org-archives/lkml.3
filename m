Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab3CANQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:16:59 -0500
Received: from service87.mimecast.com ([91.220.42.44]:59075 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3CANQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:16:58 -0500
Message-ID: <5130AA44.7030902@arm.com>
Date: Fri, 01 Mar 2013 13:16:52 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Pawel Moll <Pawel.Moll@arm.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] virtio-spec: Define virtio-mmio registers as LE
References: <87wqubkalj.fsf@rustcorp.com.au>  <1360839247-9131-1-git-send-email-pawel.moll@arm.com>  <513085EA.8070007@arm.com> <1362135005.3052.26.camel@hornet>  <51308F22.7040303@arm.com> <1362141432.3052.28.camel@hornet>
In-Reply-To: <1362141432.3052.28.camel@hornet>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 01 Mar 2013 13:16:53.0717 (UTC) FILETIME=[0ABD7850:01CE167F]
X-MC-Unique: 113030113165602601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/13 12:37, Pawel Moll wrote:
> On Fri, 2013-03-01 at 11:21 +0000, Marc Zyngier wrote:
>>> Having said that, Rusty was contemplating enforcing LE config space in
>>> the new PCI layout...
>>
>> I wouldn't complain about that, and would like to see a similar thing on
>> MMIO.
> 
> Wherever PCI goes, MMIO follows :-)

Sweet. Makes my life easier ;-).

>> Well, it was unclear enough for me to get confused... ;-) It would make
>> sense to have a wording similar to the one in the PCI section.
> 
> How about this?
> 
> 8<---------
> From a80f01f15397395a8fc49ef424a2d47c8be0937a Mon Sep 17 00:00:00 2001
> From: Pawel Moll <pawel.moll@arm.com>
> Date: Fri, 1 Mar 2013 12:35:06 +0000
> Subject: [PATCH] virtio-spec: Clarify virtio-mmio configuration space organisation
> 
> To clarify potential confusion regarding the configuration
> space organisation (endianness in particular) the spec
> should clearly state that it follows the PCI device behaviour.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Looks good to me!

	M.
-- 
Jazz is not dead. It just smells funny...

