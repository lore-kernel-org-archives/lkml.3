Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaG1HYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:24:24 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:65316 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaG1HYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:24:22 -0400
MIME-Version: 1.0
In-Reply-To: <9c56a845-2005-49c5-90c3-1d22a89fad20@email.android.com>
References: <1406288074-28725-1-git-send-email-pramod.gurav@smartplayin.com>
	<20140725162258.GA12254@core.coreip.homeip.net>
	<CAMf-jSm1d0wAJ3C_yFhqnoDPSLqeDcc-ow0D=bwmLUcC9sXjLA@mail.gmail.com>
	<9c56a845-2005-49c5-90c3-1d22a89fad20@email.android.com>
Date: Mon, 28 Jul 2014 12:54:20 +0530
Message-ID: <CAMf-jSngNZC4DT9oK52f9zPRPzbhp6yBKLjrunH1hknSwiqRuw@mail.gmail.com>
Subject: Re: [PATCH v2] Input: soc_button_array: Remove kfree on data
 allocated with devm_zalloc
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Lejun Zhu <lejun.zhu@linux.intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 12:40 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On July 27, 2014 11:50:41 PM PDT, pramod gurav <pramod.gurav.etc@gmail.com> wrote:
>>Hi Dmitry,
>>

>
> No need to resend, I picked out the good bits and applied.
Thanks. :)


-- 
Thanks and Regards
Pramod
