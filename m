Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaCGPyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:54:11 -0500
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:52523 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751033AbaCGPyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:54:09 -0500
Message-ID: <5319EB9E.7020900@codethink.co.uk>
Date: Fri, 07 Mar 2014 15:54:06 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: linux-media@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
        linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 1/5] r8a7790.dtsi: add vin[0-3] nodes
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk> <1394197299-17528-2-git-send-email-ben.dooks@codethink.co.uk> <5319F7AA.7040305@cogentembedded.com>
In-Reply-To: <5319F7AA.7040305@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/14 16:45, Sergei Shtylyov wrote:
> Hello.
>
> On 03/07/2014 04:01 PM, Ben Dooks wrote:
>
>> Add nodes for the four video input channels on the R8A7790.
>
>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>
>     This patch should have been preceded by the VIN driver patch and
> bindings description, don't you think?

Given this is a pretty standard device and video input binding
as already described in the relevant documentation, didn't really
think it was necessary.

>> diff --git a/arch/arm/boot/dts/r8a7790.dtsi
>> b/arch/arm/boot/dts/r8a7790.dtsi
>> index a1e7c39..4c3eafb 100644
>> --- a/arch/arm/boot/dts/r8a7790.dtsi
>> +++ b/arch/arm/boot/dts/r8a7790.dtsi
>> @@ -395,6 +395,38 @@
>>           status = "disabled";
>>       };
>>
>> +    vin0: vin@0xe6ef0000 {
>
>     ePAPR standard [1] tells us that:
>
> The name of a node should be somewhat generic, reflecting the function
> of the device and not its precise programming model.
>
>     So, I would suggest something like "video". And remove "0x" from the
> address part of the node name please.

vin is a reasonable contraction of video-input.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
