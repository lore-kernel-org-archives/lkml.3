Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3KVABd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 19:01:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38391 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3KVABb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 19:01:31 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <528E9EB2.3060808@jp.fujitsu.com>
Date: Fri, 22 Nov 2013 09:00:50 +0900
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
References: <528C740A.6010407@jp.fujitsu.com>  <1384963376.20536.3.camel@x230> <528DD3E0.3050606@jp.fujitsu.com> <1385064722.12107.1.camel@x230>
In-Reply-To: <1385064722.12107.1.camel@x230>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/22 5:12), Matthew Garrett wrote:
> On Thu, 2013-11-21 at 18:35 +0900, Yasuaki Ishimatsu wrote:
>
>> Remaining space is free space that can be used by efi variable. But by 5KB
>> threshold, we cannot use the space while running OS.
>
> Is the situation something like(assuming a 128KB flash part):
>
> 1) 64KB of variables, 59KB of deleted variables, 5KB of free space,

My situation looks like this. The free space spreads out if gc runs.

Thanks,
Yasuaki Ishimatsu


>
> or
>
> 2) 123KB of variables, 5KB of free space
>
> ?
>


