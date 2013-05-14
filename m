Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab3ENHwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:52:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36756 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab3ENHwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:52:53 -0400
Date: Tue, 14 May 2013 15:53:33 +0800
From: Adam Lee <adam.lee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: nico@fluxnic.net, Doug Anderson <dianders@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>, Chris Ball <cjb@laptop.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Johan Rudholm <johan.rudholm@stericsson.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: core: Add a capability for disabling mmc cards
Message-ID: <20130514075333.GA22435@adam-laptop>
Mail-Followup-To: linux-kernel@vger.kernel.org, nico@fluxnic.net,
	Doug Anderson <dianders@chromium.org>,
	Alim Akhtar <alim.akhtar@samsung.com>, Chris Ball <cjb@laptop.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Johan Rudholm <johan.rudholm@stericsson.com>,
	Jaehoon Chung <jh80.chung@samsung.com>,
	Konstantin Dorfman <kdorfman@codeaurora.org>,
	linux-mmc@vger.kernel.org
References: <1368517100-22243-1-git-send-email-adam.lee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368517100-22243-1-git-send-email-adam.lee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 03:38:17PM +0800, Adam Lee wrote:
> On some systems we need a way to disable MMC card support in a MMC/SD
> card slot due to the legal concern.
> 
> Add support in the core SD/MMC code to support this.

CC more addresses.

Yes, this capability seems odd, but linux computer vendors need this to
avoid legal problems. Please review, thanks.

-- 
Regards,
Adam Lee
Hardware Enablement
