Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab3HGKF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:05:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52028 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab3HGKF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:05:28 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <52021BD7.6010903@jp.fujitsu.com>
Date: Wed, 07 Aug 2013 19:05:11 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        jingbai.ma@hp.com
Subject: Re: [Help Test] kdump, x86, acpi: Reproduce CPU0 SMI corruption issue
 after unsetting BSP flag
References: <5200BFB3.2050202@jp.fujitsu.com> <CAErSpo5O8RbL=h5jrD3NkBhH6ARhMOag9JfUzPEED0cBfDSwxQ@mail.gmail.com>
In-Reply-To: <CAErSpo5O8RbL=h5jrD3NkBhH6ARhMOag9JfUzPEED0cBfDSwxQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/07 1:25), Bjorn Helgaas wrote:
> On Tue, Aug 6, 2013 at 3:19 AM, HATAYAMA Daisuke
> <d.hatayama@jp.fujitsu.com> wrote:
>> So, could anyone help testing the idea 2) above if you have which of
>> the following machines? (or other ones that can lead to the same bug)
>>
>> - HP Compaq 6910p
>> - HP Compaq 6710b
>> - HP Compaq 6710s
>> - HP Compaq 6510b
>> - HP Compaq 2510p
>
> Sorry, I don't have access to any of these machines any more, and I
> don't have any useful advice for you.
>

I have guessed that answer from the change of your email address...

But thanks for your record in commit and bugzilla. It's helpful to follow
details of this bug.

-- 
Thanks.
HATAYAMA, Daisuke

