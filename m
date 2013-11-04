Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3KDHJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 02:09:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36532 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3KDHJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 02:09:50 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <527747E2.3070405@jp.fujitsu.com>
Date: Mon, 04 Nov 2013 16:08:18 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: jerry.hoemann@hp.com, hpa@linux.intel.com, ebiederm@xmission.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6> <20131022220803.GA32387@anatevka.fc.hp.com> <526712B2.7070108@jp.fujitsu.com> <20131031005812.GA15459@anatevka.fc.hp.com> <20131031132744.GB3392@redhat.com>
In-Reply-To: <20131031132744.GB3392@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/31 22:27), Vivek Goyal wrote:
> On Wed, Oct 30, 2013 at 06:58:13PM -0600, jerry.hoemann@hp.com wrote:
>
> [..]
>> Daisuke,
>>
>> Are you planning on making changes to the kexec tools to automate
>> the setting of disable_cpu_apic to the capture kernel? Or do you
>> know someone who is planning this?
>
> I think we should not make this change in kexec-tools and should leave
> it to distro scripts to append disable_cpu_apic.
>
> Who knows in future this restriction is not there at all and kexec-tools
> will be stuck with always passing disable_cpu_apic. Getting rid of
> this parameter in distro scripts will be much easier.
>
> Thanks
> Vivek
>

Yes, I'll post the patch to distribution's kexec-tools. ``kexec-tools''
seems a little ambiguous; the users scripts on fedora are contained
in the same package.

I don't know things on other distributions mostly at all; I've read
Ubuntu's scripts really a little bit only. I'd like anyone to post patches
if necessary...

BTW, what's the status of this patch set? I've redesigned this so as to
be done with kernel parameter in order not to depend on platform specific
BIOS table. Due to the redesign, I think now ACK is needed again.

-- 
Thanks.
HATAYAMA, Daisuke

