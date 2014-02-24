Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaBXTkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:40:41 -0500
Received: from void.printf.net ([89.145.121.20]:46596 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbaBXTki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:40:38 -0500
From: Chris Ball <chris@printf.net>
To: Matt Porter <mporter@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>, Axel Lin <axel.lin@ingics.com>,
        Alex Elder <elder@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v4 5/8] mmc: sdhci-bcm-kona: Add basic use of clocks
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
	<1386271244-3927-6-git-send-email-tim.kryger@linaro.org>
	<CAEPRUYrPXf7QNzput0bz_UPfytRy1eYgyOJYnH5v2v4DCEKSNA@mail.gmail.com>
	<CAAYSxhoCrveHd5Wkc7Z0qzpGr41qG6-neYSSsuHQuC7AcuJmZQ@mail.gmail.com>
	<CAAYSxhrBSv8_Z1SfB-b3iGgq218Gttny4FEgYJnLtSFhJd2UFg@mail.gmail.com>
	<20140224193301.GW5038@beef>
Date: Mon, 24 Feb 2014 19:40:35 +0000
In-Reply-To: <20140224193301.GW5038@beef> (Matt Porter's message of "Mon, 24
	Feb 2014 14:33:01 -0500")
Message-ID: <86ha7os3ik.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 24 2014, Matt Porter wrote:
> Chris: we no longer need this to be taken through arm-soc since removing
> the dependency. Could you please take this patch through your tree for
> 3.15?

Thanks, pushed to mmc-next for 3.15.

- Chris.
-- 
Chris Ball   <chris@printf.net>   <http://printf.net/>
