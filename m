Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3H3B5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 21:57:21 -0400
Received: from void.printf.net ([89.145.121.20]:51407 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab3H3B5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 21:57:19 -0400
From: Chris Ball <cjb@laptop.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: "'Mischa Jonker'" <Mischa.Jonker@synopsys.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vineet.Gupta1@synopsys.com
Subject: Re: [PATCH] mmc/dw_mmc: Add support for ARC
References: <1377715229-2414-1-git-send-email-mjonker@synopsys.com>
	<001701cea4b0$19b00b10$4d102130$%jun@samsung.com>
Date: Thu, 29 Aug 2013 21:57:12 -0400
In-Reply-To: <001701cea4b0$19b00b10$4d102130$%jun@samsung.com> (Seungwon
	Jeon's message of "Thu, 29 Aug 2013 21:05:49 +0900")
Message-ID: <87ppswvt3b.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 29 2013, Seungwon Jeon wrote:
> On Thu, August 29, 2013, Mischa Jonker wrote:
>> Adapt Kconfig to include ARC in supported architectures
>> 
>> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Thanks, pushed to mmc-next for 3.12.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
