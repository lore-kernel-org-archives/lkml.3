Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaIRADY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:03:24 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:61546 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaIRADX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:03:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140914200152.GV12361@n2100.arm.linux.org.uk>
References: <1410256619-3213-1-git-send-email-ankit.jindal@linaro.org>
 <1410256619-3213-3-git-send-email-ankit.jindal@linaro.org> <20140914200152.GV12361@n2100.arm.linux.org.uk>
From: Ankit Jindal <ankit.jindal@linaro.org>
Date: Thu, 18 Sep 2014 05:33:02 +0530
Message-ID: <CAPTm99VHV-qk8FByvibmE0j3m9vHe0XYBK71-qZrW87y2y9cMw@mail.gmail.com>
Subject: Re: [PATCH 2/5] Documentation: Update documentation for UIO_MEM_PHYS_CACHE
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "patches@apm.com" <patches@apm.com>, Rob Herring <robh+dt@kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 September 2014 01:31, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Sep 09, 2014 at 03:26:56PM +0530, Ankit Jindal wrote:
>> This patch update UIO documentation for new mem region
>> type UIO_MEM_PHYS_CACHE.
>>
>> Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
>> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
>> ---
>>  Documentation/DocBook/uio-howto.tmpl |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
>> index bbe9c1f..49e47d4 100644
>> --- a/Documentation/DocBook/uio-howto.tmpl
>> +++ b/Documentation/DocBook/uio-howto.tmpl
>> @@ -530,7 +530,8 @@ the memory region, it will show up in the corresponding sysfs node.
>>  <varname>UIO_MEM_PHYS</varname> if you you have physical memory on your
>>  card to be mapped. Use <varname>UIO_MEM_LOGICAL</varname> for logical
>>  memory (e.g. allocated with <function>kmalloc()</function>). There's also
>> -<varname>UIO_MEM_VIRTUAL</varname> for virtual memory.
>> +<varname>UIO_MEM_VIRTUAL</varname> for virtual memory and
>> +<varname>UIO_MEM_PHYS_CACHE</varname> for physical cacheable memory.
>
> When I read this, I wondered what "physical cacheable memory" was.
> Then I found that what you're doing with this is mapping physical
> memory into userspace with cacheable attributes.
>
> So, to avoid confusion, this should be "for physical memory, which
> will be cacheably mapped" or similar.

Thanks, will frame better in next version.

Thanks,
Ankit
