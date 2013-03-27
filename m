Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab3C0R6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:58:24 -0400
Received: from void.printf.net ([89.145.121.20]:35413 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab3C0R6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:58:22 -0400
From: Chris Ball <cjb@laptop.org>
To: Grant Grundler <grundler@chromium.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Will Newton <will.newton@gmail.com>, Bing Zhao <bzhao@marvell.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: dw_mmc: rewrite CLKDIV computation
References: <1364338202-10311-1-git-send-email-grundler@chromium.org>
	<000b01ce2ae6$249bfb90$6dd3f2b0$%jun@samsung.com>
	<CANEJEGsLqAdZqLV+c59nT97ErdAOSRWTPJpYye7m64_i7ga0rg@mail.gmail.com>
Date: Wed, 27 Mar 2013 13:58:16 -0400
In-Reply-To: <CANEJEGsLqAdZqLV+c59nT97ErdAOSRWTPJpYye7m64_i7ga0rg@mail.gmail.com>
	(Grant Grundler's message of "Wed, 27 Mar 2013 10:51:51 -0700")
Message-ID: <87ip4cbu87.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Wed, Mar 27 2013, Grant Grundler wrote:
> On Wed, Mar 27, 2013 at 5:25 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
>> On Wednesday, March 27, 2013, Grant Grundler wrote:
>>> Last year Seungwon Jeon (Samsung) fixed a bug in CLKDIV computation.
>> For easily identifying, it would be good to point the commit id and subject.
>
> commit id will be different for different git trees and branches - not
> as useful as one might think.
>
> I will include the following and update the patch:
>    Author: Seungwon Jeon <tgih.jun@samsung.com>
>    Date:   Tue May 22 13:01:21 2012 +0900
>    mmc: dw_mmc: correct the calculation for CLKDIV

Please use the following (standard) syntax in the commit message:

Commit e419990b5e8 ("mmc: dw_mmc: correct the calculation for CLKDIV")
fixed a bug in CLKDIV computation.  [..]

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
