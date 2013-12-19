Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab3LSXDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:03:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41285 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3LSXDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:03:19 -0500
Date: Thu, 19 Dec 2013 15:03:15 -0800
From: David Brown <davidb@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, gregkh@linuxfoundation.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/15]  usb: phy: msm: Fixes, cleanups and DT support
Message-ID: <20131219230315.GA20875@codeaurora.org>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
 <20131126163846.GF24310@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20131126163846.GF24310@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:38:46AM -0600, Felipe Balbi wrote:
>Hi,
>
>On Tue, Nov 12, 2013 at 04:51:35PM +0200, Ivan T. Ivanov wrote:
>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>>
>> Hi,
>>
>> Patches have been tested on top of Stephen's clock controller
>> patches[1] and recent fixes for chipidea msm glue layer driver
>> posted here[2]. Hardware platform AP8074 DragonBoard. Only gadget
>> mode utilized for now.
>>
>> CV Test Suite engine "Chapter 9 tests" are passing except
>> "Halt Endpoint Test".
>>
>> usbtest driver report following failure:
>> test 13 --> 32 (Broken pipe) 		ep 81 couldn't set halt, -32
>>
>> This will be investigated further.
>> Patches could be applied cleanly on top of the usb-3.13-rc1.
>>
>> Regards,
>> Ivan
>>
>> [1] http://comments.gmane.org/gmane.linux.ports.arm.msm/5375
>> [2] https://lkml.org/lkml/2013/11/11/310
>
>I wonder how will this be taken upstream provided there are
>interdependencies between arch/ and drivers/ patches.
>
>I can Ack patches but I'd really like to avoid merging of topic branches
>all over the place :-s

Ivan's patches are the only ones in this window that touch these board
files in MSM.  It's probably easiest if I ack them, and you can bring
the whole series through your tree.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
