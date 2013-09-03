Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370Ab3ICSNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:13:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57769 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760065Ab3ICSNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:13:36 -0400
Message-ID: <522626CC.70804@wwwdotorg.org>
Date: Tue, 03 Sep 2013 12:13:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-tegra@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Introduce table driven initializations
References: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 07:31 AM, Peter De Schrijver wrote:
> This patchset introduces a table driven initialization method for the
> audio, PMC and gate clocks. It's similar to the table we already have for
> the periph clocks.

I assume these patches will all go through Mike's clock tree for 3.13.

Aside from the one issue I mentioned, the series,
Acked-by: Stephen Warren <swarren@nvidia.com>

I assume this will be followed by changes to convert the Tegra20/30
clock drivers to be table-based too?

>  2 files changed, 455 insertions(+), 550 deletions(-)

That didn't work out as much of a line-count-reduction as I had naively
hoped. Are there any more large blocks of repetitive code left to be
converted?
