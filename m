Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3A1VPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:15:23 -0500
Received: from void.printf.net ([89.145.121.20]:52007 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab3A1VPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:15:19 -0500
From: Chris Ball <cjb@laptop.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Will Newton <will.newton@gmail.com>, linux-mmc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v4 5/5] mmc: dw_mmc: Remove DW_MCI_QUIRK_NO_WRITE_PROTECT
References: <1357842269-15062-1-git-send-email-dianders@chromium.org>
	<1357923834-31641-1-git-send-email-dianders@chromium.org>
	<1357923834-31641-5-git-send-email-dianders@chromium.org>
	<CAFbHwiTafLhK-uJKjUX4_yLC+27OOUnC2JxYM9-3rHZkPx7s5Q@mail.gmail.com>
	<CAD=FV=XEfydu-0oD-Vc_uwqt6qRU9Fs9ROgta3FugSEmPp7nFA@mail.gmail.com>
Date: Mon, 28 Jan 2013 16:14:19 -0500
In-Reply-To: <CAD=FV=XEfydu-0oD-Vc_uwqt6qRU9Fs9ROgta3FugSEmPp7nFA@mail.gmail.com>
	(Doug Anderson's message of "Mon, 14 Jan 2013 08:09:56 -0800")
Message-ID: <87k3qx80yc.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Mon, Jan 14 2013, Doug Anderson wrote:
> The whole bundle of all 5 patches at v4 is here:
>     http://patchwork.kernel.org/bundle/dianders/mmc_wp/

Thanks, I've pushed all 5 to mmc-next for 3.9 now with the collected ACKs.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
