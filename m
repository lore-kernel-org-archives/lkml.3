Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3LCFNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 00:13:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58603 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3LCFNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 00:13:11 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <529D6834.2070408@jp.fujitsu.com>
Date: Tue, 3 Dec 2013 14:12:20 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "matt@console-pimps.org" <matt@console-pimps.org>,
        "richard@nod.at" <richard@nod.at>, "cxie@redhat.com" <cxie@redhat.com>
Subject: Re: [PATCH] x86, efi: add efi_whitelist_table to use all efi variable
 storage
References: <528DD3E0.3050606@jp.fujitsu.com> <1385064722.12107.1.camel@x230> <528E9EB2.3060808@jp.fujitsu.com> <1385078632.12107.3.camel@x230> <528EF87D.4050300@jp.fujitsu.com> <528EF9CE.2070305@jp.fujitsu.com> <1385142450.2884.1.camel@x230> <529D4DF5.80502@jp.fujitsu.com> <25e63f3b748741998d2b3e04bbc53064@BN1PR05MB423.namprd05.prod.outlook.com> <529D62C0.2080400@jp.fujitsu.com> <20131203050450.GA30967@srcf.ucam.org>
In-Reply-To: <20131203050450.GA30967@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/03 14:04), Matthew Garrett wrote:
> On Tue, Dec 03, 2013 at 01:49:04PM +0900, Yasuaki Ishimatsu wrote:
>
>> What boot service is the "boot services" in these sentences?
>
> The environment prior to ExitBootServices() being called.
>

I see.
I'll check it.

Thank,
Yasuaki Ishimatsu

