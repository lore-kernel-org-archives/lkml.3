Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3HYCWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 22:22:18 -0400
Received: from void.printf.net ([89.145.121.20]:36145 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab3HYCWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 22:22:16 -0400
From: Chris Ball <cjb@laptop.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Markos Chandras'" <markos.chandras@imgtec.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: dw_mmc: Handle DW_MCI_QUIRK_IDMAC_DTO properly
References: <1373400280-7408-1-git-send-email-dianders@chromium.org>
	<002901ce7d7d$65223e10$2f66ba30$%jun@samsung.com>
Date: Sat, 24 Aug 2013 22:22:10 -0400
In-Reply-To: <002901ce7d7d$65223e10$2f66ba30$%jun@samsung.com> (Seungwon
	Jeon's message of "Wed, 10 Jul 2013 23:54:36 +0900")
Message-ID: <87d2p2tsq5.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 10 2013, Seungwon Jeon wrote:
> On Wed, July 10, 2013, Doug Anderson wrote:
>> In (1fb5f68 mmc: dw_mmc: Don't loop when handling an interrupt), the
>> code for handling DW_MCI_QUIRK_IDMAC_DTO became dead code.  Move it to
>> where it ought to live.
>> 
>> Found by code inspection and compile-tested only--I don't know of any
>> boards that need DW_MCI_QUIRK_IDMAC_DTO.
>> 
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Thanks, pushed to mmc-next for 3.12.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
