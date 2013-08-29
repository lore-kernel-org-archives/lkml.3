Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3H2XxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:53:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51988 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3H2XxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:53:03 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <521FDE8D.4040807@jp.fujitsu.com>
Date: Fri, 30 Aug 2013 08:51:41 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: ebiederm@xmission.com, vgoyal@redhat.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        jingbai.ma@hp.com
Subject: Re: [PATCH 0/2] x86, apic: Disable BSP if boot cpu is AP
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6> <521F5297.4070906@linux.intel.com>
In-Reply-To: <521F5297.4070906@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/29 22:54), H. Peter Anvin wrote:
> On 08/29/2013 02:27 AM, HATAYAMA Daisuke wrote:
>> This is the patch series to address the issue that kdump 2nd kernel
>> now fails to wake up multiple CPUs.
>
> Please explain the "now" in the above sentence.  Is this a regression?
> If so, what is its impact?  Is this something that needs to go into 3.11
> as a post-rc7 change, which means it better be hyper-critical?
>
> 	-hpa
>
>

This is not a regression just as Eric explains.

There is also my explanation in the description of the 2nd patch. I should have described so here explicitly.

-- 
Thanks.
HATAYAMA, Daisuke

