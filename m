Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaFSJUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:20:52 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:56688 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbaFSJUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:20:49 -0400
Date: Thu, 19 Jun 2014 10:20:42 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, srinivas.kandagatla@gmail.com,
        thierry.reding@gmail.com
Subject: Re: [STLinux Kernel] [PATCH 4/7] ARM: stih416-b2020e: Enable PWM on
 the B2020 Rev-E
Message-ID: <20140619092042.GB26560@lee--X1>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
 <1403103172-19856-4-git-send-email-lee.jones@linaro.org>
 <20140619090546.GB2131@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140619090546.GB2131@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > All the infrastructure is now in place for ST's PWM controller.  This
> > patch takes the final step and enables the IP on the 2020 Rev-E
> > development platform.
> 
> Why are you only enabling this for rev-E board?

Purely for testing purposes, as it's the only board I have.  If
anyone has the other revisions and would be happy to test the driver
for me then great.

> If you make the stih415 DT PWM nodes part of this series as well, then 
> assuming there is no good reason to the contary, the PWM could 
> be enabled for both stih415/6 in the common stih41x-b2020 DTS file which
> is also included by rev-E (assuming that PWM wiring is not some rev-E specific
> thing).
> 
> Also Ajit Signed-off-by needs adding to this series.

As you know, Thierry already picked this up.

Will fix for v2.

> After that:
> Acked-by: Peter Griffin <peter.griffin@linaro.org>

Thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
