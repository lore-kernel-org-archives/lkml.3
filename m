Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaIXT0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:26:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46540 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaIXT0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:26:14 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] ARM: qcom: Update SoC compatibles we support
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <54230E9A.7020109@codeaurora.org>
Date: Wed, 24 Sep 2014 14:26:10 -0500
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <42858D66-62FA-4F89-A1A2-584DD6A7BE34@codeaurora.org>
References: <1411582838-24159-1-git-send-email-galak@codeaurora.org> <54230E9A.7020109@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 24, 2014, at 1:34 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 09/24/14 11:20, Kumar Gala wrote:
>> Move to just using the SoC name in the compatible list so we don't need
>> to update this for every board going forward.  Also added "qcom,msm8974"
>> to the list as we support "qcom,apq8074" already (the modemless version
>> of "qcom,msm8974").
>> 
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
> 
> Or just remove the file entirely. Things work without having to add
> anything here anyway.

I’d prefer there to be some filter, but maybe you are right.  I doubt we’ll add too many other platforms to this going forward.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

