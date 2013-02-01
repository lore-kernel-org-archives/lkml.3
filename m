Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3BAEUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 23:20:49 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64278 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3BAEUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 23:20:46 -0500
MIME-Version: 1.0
In-Reply-To: <510AA318.5060208@wwwdotorg.org>
References: <1359627939-2685-1-git-send-email-sachin.kamat@linaro.org>
	<1359627939-2685-3-git-send-email-sachin.kamat@linaro.org>
	<510AA318.5060208@wwwdotorg.org>
Date: Fri, 1 Feb 2013 09:50:45 +0530
Message-ID: <CAK9yfHzSq8SpKXQYtFd1Ds+N-AoH+H+BdWrPsPT=OwSPdst1WA@mail.gmail.com>
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

On 31 January 2013 22:30, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/31/2013 03:25 AM, Sachin Kamat wrote:
>> Use the newly introduced devm_ioremap_resource() instead of
>> devm_request_and_ioremap() which provides more consistent error handling.
>
> Presumably though that function isn't yet available in the tree that
> this new serial driver was merged through is it?

The entire series is merged in Greg's driver-core tree [1] and I
presume all other associated patches would also be picked up by him.
Isn't it Greg?

[1] git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git

-- 
With warm regards,
Sachin
