Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbaFSJFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:05:54 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:53815 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772AbaFSJFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:05:51 -0400
Date: Thu, 19 Jun 2014 10:05:46 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, srinivas.kandagatla@gmail.com,
        thierry.reding@gmail.com
Subject: Re: [STLinux Kernel] [PATCH 4/7] ARM: stih416-b2020e: Enable PWM on
 the B2020 Rev-E
Message-ID: <20140619090546.GB2131@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
 <1403103172-19856-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403103172-19856-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

> All the infrastructure is now in place for ST's PWM controller.  This
> patch takes the final step and enables the IP on the 2020 Rev-E
> development platform.

Why are you only enabling this for rev-E board?

If you make the stih415 DT PWM nodes part of this series as well, then 
assuming there is no good reason to the contary, the PWM could 
be enabled for both stih415/6 in the common stih41x-b2020 DTS file which
is also included by rev-E (assuming that PWM wiring is not some rev-E specific
thing).

Also Ajit Signed-off-by needs adding to this series.

After that:
Acked-by: Peter Griffin <peter.griffin@linaro.org>

regards,

Peter.
