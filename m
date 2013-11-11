Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3KKIyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:54:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41129 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3KKIyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:54:05 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52809AEB.9080100@jp.fujitsu.com>
Date: Mon, 11 Nov 2013 17:52:59 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Richard Weinberger <richard@nod.at>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <matt.fleming@intel.com>,
        <matthew.garrett@nebula.com>, <jlee@suse.com>
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia parameter
 to efi_storage_paranoia
References: <527C93B5.7010407@jp.fujitsu.com> <527C9B5C.6040509@nod.at> <527CB013.30200@jp.fujitsu.com> <527CB0F4.8080606@nod.at> <527CBC05.6080505@jp.fujitsu.com> <527CBD01.1000908@nod.at> <527CBDD3.2020609@jp.fujitsu.com> <20131108143421.GB22636@console-pimps.org>
In-Reply-To: <20131108143421.GB22636@console-pimps.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

I uses FUJITSU's x86 box.
This does not become bricked even if I use all efi variable storage.
Thus I want a way to not need to specify efi_no_storage_paranoia
parameter.

Thanks,
Yasuaki Ishimatsu


(2013/11/08 23:34), Matt Fleming wrote:
> On Fri, 08 Nov, at 07:32:51PM, Yasuaki Ishimatsu wrote:
>>> Everything started with an issue that killed Samsung laptops:
>>> http://mjg59.dreamwidth.org/22855.html
>>>
>>> Later it was found that if you write too much into UEFI variables many
>>> UEFI implementations will do bad things.
>>
>> Thanks for the information.
>> I will read it.
>
> Out of curiosity, what hardware are you using?
>


