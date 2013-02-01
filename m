Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab3BAJti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:49:38 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:49709 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab3BAJtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:49:33 -0500
MIME-Version: 1.0
In-Reply-To: <510B436A.20808@wwwdotorg.org>
References: <1359627939-2685-1-git-send-email-sachin.kamat@linaro.org>
	<1359627939-2685-3-git-send-email-sachin.kamat@linaro.org>
	<510AA318.5060208@wwwdotorg.org>
	<CAK9yfHzSq8SpKXQYtFd1Ds+N-AoH+H+BdWrPsPT=OwSPdst1WA@mail.gmail.com>
	<510B436A.20808@wwwdotorg.org>
Date: Fri, 1 Feb 2013 15:19:32 +0530
Message-ID: <CAK9yfHzJvOC_wvsxvapi7rATq97QX-6exOyqjNTSguhh3RLVvQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] serial: tegra: Convert to devm_ioremap_resource()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, thierry.reding@avionic-design.de,
        gregkh@linuxfoundation.org, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 February 2013 09:54, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>
>> The entire series is merged in Greg's driver-core tree [1] and I
>> presume all other associated patches would also be picked up by him.
>> Isn't it Greg?
>>
>> [1] git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
>
> The Tegra serial driver went through Greg's TTY tree. I assume that goes
> direct to Linus not through driver-core.git first.

Right. But AFAIK for this specific change he has carried the patches
in the device-core tree irrespective of the subsystem.


-- 
With warm regards,
Sachin
