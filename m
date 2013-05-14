Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3ENLUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:20:04 -0400
Received: from void.printf.net ([89.145.121.20]:35981 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab3ENLUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:20:02 -0400
From: Chris Ball <cjb@laptop.org>
To: linux-kernel@vger.kernel.org
Cc: nico@fluxnic.net, Doug Anderson <dianders@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Johan Rudholm <johan.rudholm@stericsson.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: core: Add a capability for disabling mmc cards
References: <1368517100-22243-1-git-send-email-adam.lee@canonical.com>
	<20130514075333.GA22435@adam-laptop>
Date: Tue, 14 May 2013 07:19:48 -0400
In-Reply-To: <20130514075333.GA22435@adam-laptop> (Adam Lee's message of "Tue,
	14 May 2013 15:53:33 +0800")
Message-ID: <874ne5n6zv.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 14 2013, Adam Lee wrote:
> On Tue, May 14, 2013 at 03:38:17PM +0800, Adam Lee wrote:
>> On some systems we need a way to disable MMC card support in a MMC/SD
>> card slot due to the legal concern.
>> 
>> Add support in the core SD/MMC code to support this.
>
> CC more addresses.
>
> Yes, this capability seems odd, but linux computer vendors need this to
> avoid legal problems. Please review, thanks.

This has already been NACKed by Nicolas:

https://patchwork.kernel.org/patch/1359121/

(At least, I think it has -- your forward doesn't include the patch
itself.)

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
