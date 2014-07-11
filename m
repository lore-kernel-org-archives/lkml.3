Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaGKLOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:14:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51666 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaGKLOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:14:40 -0400
Message-ID: <53BFC6F4.2060804@ti.com>
Date: Fri, 11 Jul 2014 16:43:56 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>, Lee Jones <lee.jones@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kernel@stlinux.com>
Subject: Re: [STLinux Kernel] [PATCH v3 0/5] phy: miphy365x: Introduce support
 for MiPHY365x
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org> <53BD572C.4060406@ti.com> <20140710153548.GB26886@griffinp-ThinkPad-X1-Carbon-2nd> <20140711103104.GC30519@lee--X1> <20140711110547.GA23439@griffinp-ThinkPad-X1-Carbon-2nd>
In-Reply-To: <20140711110547.GA23439@griffinp-ThinkPad-X1-Carbon-2nd>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 11 July 2014 04:35 PM, Peter Griffin wrote:
> Hi Lee,
> 
> On Fri, 11 Jul 2014, Lee Jones wrote:
>>> One small point, patch 5 which adds the DT nodes may not apply as the file got
>>> renamed from stih416-b2020-revE.dts to stih416-b2020e.dts.
>>
>> Not required, Git should handle this seamlessly.
> 
> I didn't ask you to do anything.
> 
> Also when I made the same mistake, GIT
> did not handle it seamlessly and I got the following query
> from Ulf http://www.mail-archive.com/devicetree@vger.kernel.org/msg33926.html
> 
> So in case Kishon has the same problem I thought I'd do a pre-emptive strike!

thanks.. but I wouldn't be merging the dt node stuff. I think the second patch
is shared by both dt patch and driver. In that case one of me or whoever merges
the dt patch will create a branch and both of us will merge it.

Lee,
Your cover letter did not have the patch subjects. When you send the next
version can you use --cover-letter option to create the cover letter?

Thanks
Kishon
