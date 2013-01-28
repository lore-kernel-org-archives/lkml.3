Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3A1Vmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:42:47 -0500
Received: from void.printf.net ([89.145.121.20]:56700 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab3A1Vmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:42:45 -0500
From: Chris Ball <cjb@laptop.org>
To: Will Newton <will.newton@gmail.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        open list <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        Will Newton <will.newton@imgtec.com>, jh80.chung@samsung.com,
        James Hogan <james.hogan@imgtec.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH] MAINTAINERS: mmc: add maintainer entry for dw_mmc driver
References: <000c01cdf4ae$d77888a0$866999e0$%jun@samsung.com>
	<CAFbHwiSZf2haZZ+ohs7EY+Ex3t9cwyJoJmBVfD=HLj0WmskDxQ@mail.gmail.com>
Date: Mon, 28 Jan 2013 16:42:12 -0500
In-Reply-To: <CAFbHwiSZf2haZZ+ohs7EY+Ex3t9cwyJoJmBVfD=HLj0WmskDxQ@mail.gmail.com>
	(Will Newton's message of "Thu, 17 Jan 2013 12:40:53 +0000")
Message-ID: <87obg96l3f.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 17 2013, Will Newton wrote:
> On Thu, Jan 17, 2013 at 12:33 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
>> Add maintainer entry for the Synopsys DW host driver which
>> is used in various SOC including EXYNOS series.
>> As Will Newton will no longer be able to take care of dw_mmc*,
>> I and Jaehoon Chung are willing to maintain it.
>>
>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
>> ---
>>  MAINTAINERS |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> Acked-by: Will Newton <will.newton@imgtec.com>

Thanks, pushed to mmc-next for 3.9.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
