Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3H1SJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:09:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44486 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3H1SJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:09:28 -0400
Subject: Re: [PATCH v3 2/2] ARM: dts: msm: Update uartdm compatible strings
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <0092782E-9E89-4350-B3B5-EB1275F2F8E3@codeaurora.org>
Date: Wed, 28 Aug 2013 13:09:30 -0500
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <73376D74-0D5C-4739-A81A-1A1EC7B3463F@codeaurora.org>
References: <1377648764-23453-1-git-send-email-sboyd@codeaurora.org> <1377648764-23453-3-git-send-email-sboyd@codeaurora.org> <0092782E-9E89-4350-B3B5-EB1275F2F8E3@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 28, 2013, at 1:04 PM, Kumar Gala wrote:

> 
> On Aug 27, 2013, at 7:12 PM, Stephen Boyd wrote:
> 
>> Let's follow the ratified DT binding and use uartdm instead of
>> hsuart. This does break backwards compatibility but this
>> shouldn't be a problem because the uart driver isn't probing on
>> these devices without adding clock support (which isn't merged so
>> far).
> 
> I'm not seeing any driver upstream even using the compatibles so might be worth adding that we aren't even breaking anything upstream.
> 
> Otherwise you can add:

Ignore me, not sure what tree I was looking at.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

