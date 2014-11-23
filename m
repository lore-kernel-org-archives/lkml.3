Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaKWIe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 03:34:58 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37362 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaKWIe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 03:34:56 -0500
Message-ID: <54719C29.9070102@gmail.com>
Date: Sun, 23 Nov 2014 16:34:49 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [CFT PATCH 0/2] KVM: support XSAVES usage in the host
References: <1416594678-13011-1-git-send-email-pbonzini@redhat.com> <DE9192FA-6A22-4AEB-88C2-AE17DA503685@gmail.com> <547199B3.1040303@gmail.com> <89CF39F2-660B-4999-8D4D-08E4942C58FD@gmail.com>
In-Reply-To: <89CF39F2-660B-4999-8D4D-08E4942C58FD@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/23/14, 4:31 PM, Nadav Amit wrote:
>> On Nov 23, 2014, at 10:24, Wanpeng Li <kernellwp@gmail.com> wrote:
>>
>> Hi Nadav,
>> On 11/23/14, 4:16 PM, Nadav Amit wrote:
>>> I’ll try to check it tomorrow (I don’t have access to the failing machine at the moment).
>> If the machine you mentioned support xsaves and what's machine you are using?
> It supports xsaves. I am using an experimental setup.

Interesting, I even can't get a machine which supports xsaves.

Regards,
Wanpeng Li

>
> Nadav

