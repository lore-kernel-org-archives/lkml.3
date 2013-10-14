Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3JNDd6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 23:33:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58290 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752749Ab3JNDd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 23:33:57 -0400
Message-ID: <525B6623.8020102@free-electrons.com>
Date: Mon, 14 Oct 2013 05:33:55 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: misc: remove deprecated IRQF_DISABLED
References: <1381641051-7287-1-git-send-email-michael.opdenacker@free-electrons.com> <20131013145400.GH2954@intel.com>
In-Reply-To: <20131013145400.GH2954@intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On 10/13/2013 04:54 PM, Vinod Koul wrote:
> On Sun, Oct 13, 2013 at 07:10:51AM +0200, Michael Opdenacker wrote:
>> This patch proposes to remove the use of the IRQF_DISABLED flag
>>
>> It's a NOOP since 2.6.35 and it will be removed one day.
> Applied, thanks. Title shouldnt have misc as it doesnt convey anything.
Thanks!

Indeed, I sent separate patches for files which had different
maintainers, and grouped the patches for files which shared the same
maintainer information.

I put "misc" to avoid suggesting that the patch is for everything under
drivers/dma/, which is not the case. Wouldn't it have been confusing
otherwise?

Thanks again,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

