Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3AaRAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:00:15 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50596 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3AaRAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:00:12 -0500
Message-ID: <510AA318.5060208@wwwdotorg.org>
Date: Thu, 31 Jan 2013 10:00:08 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-kernel@vger.kernel.org, thierry.reding@avionic-design.de,
        gregkh@linuxfoundation.org, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/3] serial: tegra: Convert to devm_ioremap_resource()
References: <1359627939-2685-1-git-send-email-sachin.kamat@linaro.org> <1359627939-2685-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1359627939-2685-3-git-send-email-sachin.kamat@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 03:25 AM, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.

Presumably though that function isn't yet available in the tree that
this new serial driver was merged through is it?
