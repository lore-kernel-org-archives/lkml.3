Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaEAS7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:59:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53074 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaEAS7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:59:33 -0400
Message-ID: <53629992.70206@wwwdotorg.org>
Date: Thu, 01 May 2014 12:59:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>
CC: olof@lixom.net, lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps65090: Fix tps65090 crash on Tegra Dalmore
References: <1398970216-23519-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1398970216-23519-1-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 12:50 PM, Doug Anderson wrote:
> The patch (60e91b5 regulator: tps65090: Allow setting the overcurrent
> wait time) introduced a crash on Tegra Dalmore.  On Dalmore the device
> tree doesn't have an entry for all of the FETs so it leaves tps_pdata
> NULL in some cases.  Add a check for NULL like the rest of the code
> does.

Tested-by: Stephen Warren <swarren@nvidia.com>
