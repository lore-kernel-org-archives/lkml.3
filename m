Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3FXOjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:39:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57045 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3FXOjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:39:12 -0400
Message-ID: <51C85A0D.3070400@codeaurora.org>
Date: Mon, 24 Jun 2013 10:39:09 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Add support for LPAE style CONTEXTIDR
References: <1372080405-13365-1-git-send-email-cov@codeaurora.org> <20130624140424.GA24861@mudshark.cambridge.arm.com>
In-Reply-To: <20130624140424.GA24861@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 06/24/2013 10:04 AM, Will Deacon wrote:
[...]

> What's the advantage of this approach, other than you get an extra byte's
> worth of PID?

In my view, the real advantage is that the the PID is located where people
reading ARM Architecture Reference Manual are told they can find it.

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
