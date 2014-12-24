Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaLXJoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 04:44:25 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43321 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaLXJoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 04:44:06 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] Drivers: bcma: Fix three coding style issues, more than 80 characters per line.
From: =?iso-8859-1?Q?=D2scar_Forner_Mart=EDnez?= 
	<oscar.forner.martinez@gmail.com>
In-Reply-To: <877fxhbjj8.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 24 Dec 2014 09:44:02 +0000
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4E065003-D723-47FD-B463-C1C0C4C238E2@gmail.com>
References: <1419378909-14414-1-git-send-email-oscar.forner.martinez@gmail.com> <877fxhbjj8.fsf@kamboji.qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kalle,

I am doing it from London with the timezone of Spain, maybe is that the odd stuff? I can change it and do the patch again. I will check the style guide to do the changes properly this time. I have a couple of questions, as it is my first patch I am not sure how to do them.

Do I have to sent the V2 of the patch as the previous one? or I have to do something to follow that one?

Regards,

Oscar

On 24 Dec 2014, at 07:20, Kalle Valo <kvalo@codeaurora.org> wrote:

> Oscar Forner Martinez <oscar.forner.martinez@gmail.com> writes:
> 
>> Three lines with more than 80 characters per line have been split in several lines.
>> 
>> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
>> ---
>> drivers/bcma/driver_chipcommon.c | 10 +++++++---
>> 1 file changed, 7 insertions(+), 3 deletions(-)
> 
> Just to handle the bureaucracy before v2 is submitted:
> 
> To which tree should this go to? I see that earlier John has applied
> patches to drivers/bcma/, but what about now? Should I take these? John,
> any suggestions?
> 
> Oscar, the patchwork entry for this patch looked odd. I'm guessing it
> was because your time (or timezone) is wrong:
> 
> https://patchwork.kernel.org/patch/5535751/
> 
> -- 
> Kalle Valo

