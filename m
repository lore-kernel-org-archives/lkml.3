Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbaCUOkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:40:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35446 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbaCUOkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:40:42 -0400
Message-ID: <532C4F40.5010903@ti.com>
Date: Fri, 21 Mar 2014 10:40:00 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: boot: dts: build keystone devicetree blob
References: <1394639330-1288-1-git-send-email-balbi@ti.com> <53208CDD.7030106@ti.com>
In-Reply-To: <53208CDD.7030106@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2014 12:35 PM, Santosh Shilimkar wrote:
> On Wednesday 12 March 2014 11:48 PM, Felipe Balbi wrote:
>> Currently, even when building keystone only
>> kernel builds, DTB won't get build because
>> we lack a Makefile rule to get it compiled.
>>
>> This patch adds that rule so mainline kernel
>> users have a chance to use up-to-date DTB on
>> keystone 2 platforms.
>>
>> Signed-off-by: Felipe Balbi <balbi@ti.com>
>> ---
>>
> We have been building dtbs with explicit command
> instead of dtbs since it was just one dtb so far
> supported. Was planning to add the rule once more
> boards get added. Now with Lamarr and Edision in
> for next merge window, will do that post 3.15-rc1.
> 
Just to close the loop, I added a patch as part
of my 3.15 fixes which builds all keystone dt
blobs.

Regards,
Santosh

