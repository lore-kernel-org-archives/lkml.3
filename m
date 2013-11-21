Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3KUJgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:36:10 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38029 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3KUJgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:36:07 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <528DD3E0.3050606@jp.fujitsu.com>
Date: Thu, 21 Nov 2013 18:35:28 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "matt@console-pimps.org" <matt@console-pimps.org>,
        "richard@nod.at" <richard@nod.at>, "cxie@redhat.com" <cxie@redhat.com>
Subject: Re: [PATCH] x86, efi: add no_bricked_efi whitelist
References: <528C740A.6010407@jp.fujitsu.com> <1384963376.20536.3.camel@x230>
In-Reply-To: <1384963376.20536.3.camel@x230>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/21 1:02), Matthew Garrett wrote:
> On Wed, 2013-11-20 at 17:34 +0900, Yasuaki Ishimatsu wrote:
>
>> When booting my system, remaining space of efi variable storage is about
>> 5KB. So there is no room that sets a new variable to the storage. On my
>> system, trigger of gc is when EFI_OUT_OF_RESOURCES occurs on pre OS
>> environment with UEFI. So if EFI_OUT_OF_RESOURCES occurs by the 5Kbyte
>> threshold, nvram storage cannot be used until EFI_OUT_OF_RESOURCES occurs
>> on pre OS environment with UEFI.
>
> By "remaining space is about 5KB", do you mean that the rest of the
> space is filled with variables or do you mean that there is more free
> space but it hasn't been garbage collected?
>

Remaining space is free space that can be used by efi variable. But by 5KB
threshold, we cannot use the space while running OS.

Thanks,
Yasuaki Ishimatsu

