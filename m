Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbaDHP0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:26:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59905 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbaDHP0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:26:20 -0400
Message-ID: <5344151A.8030108@codeaurora.org>
Date: Tue, 08 Apr 2014 10:26:18 -0500
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: MSM8974: Add pinctrl node
References: <1391700529-11816-1-git-send-email-iivanov@mm-sol.com> 	 <1391700529-11816-2-git-send-email-iivanov@mm-sol.com> 	 <CAOZdJXVE7MSMBaL+bt0kjw5LEidz-aVp+vrWqQWkye6HdE7EeA@mail.gmail.com>  <1396959284.28420.45.camel@iivanov-dev> <5343EC87.700@codeaurora.org> <1396964805.28420.53.camel@iivanov-dev> <53440544.9040502@codeaurora.org>
In-Reply-To: <53440544.9040502@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 09:18 AM, Timur Tabi wrote:
>
> Back in July, Qualcomm submitted a patch that added this information
> into the device tree:
>
> http://marc.info/?t=137185166100003&r=1&w=2
>
> However, this was rejected.  Now it appears that this information is
> again being added to the device tree, but it's being accepted.  What's
> different now?

After re-reading the documentation and having someone kindly explain 
this to me, I understand it now.  The device tree is only specifying 
specific configurations that a driver wants, not the sum total of all 
possible groupings.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by the Linux Foundation.
