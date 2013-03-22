Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161052Ab3CVQme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:42:34 -0400
Received: from void.printf.net ([89.145.121.20]:34075 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161013Ab3CVQmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:42:33 -0400
From: Chris Ball <cjb@laptop.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [PATCH] mmc: dw_mmc: setpower on MMC_POWER_{UP,OFF}
References: <1363085012-9220-1-git-send-email-james.hogan@imgtec.com>
Date: Fri, 22 Mar 2013 12:42:29 -0400
In-Reply-To: <1363085012-9220-1-git-send-email-james.hogan@imgtec.com> (James
	Hogan's message of "Tue, 12 Mar 2013 10:43:32 +0000")
Message-ID: <878v5fo07e.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 12 2013, James Hogan wrote:
> Call the setpower platform callback in response to set_ios with
> ios->power_mode == MMC_POWER_UP or MMC_POWER_OFF, instead of from the
> card detect work function.
>
> This appears to fix a problem I have where a card stuck in a funny state
> doesn't get properly cleared by the power being turned off, presumably
> due to lack of power sequencing. This resulted in the following log
> messages after boot:

Thanks, pushed to mmc-next for 3.10.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
