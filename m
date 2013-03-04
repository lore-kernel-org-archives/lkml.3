Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3CDJCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:02:10 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58767 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab3CDJCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:02:08 -0500
MIME-Version: 1.0
In-Reply-To: <20130226175910.GD1225@arwen.pp.htv.fi>
References: <1361516979-7340-1-git-send-email-yhchen@faraday-tech.com>
	<20130226175910.GD1225@arwen.pp.htv.fi>
Date: Mon, 4 Mar 2013 17:02:06 +0800
Message-ID: <CADB-GoLn=PZcXgPr51stkrG=GQ7+YA7f49KW3jEyPETYbKyh7Q@mail.gmail.com>
Subject: Re: [PATCH] fusb300_udc: modify stall clear and idma reset procedure
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan-Hsin Chen <yhchen@faraday-tech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 27, 2013 at 1:59 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Feb 22, 2013 at 07:09:39AM +0000, Yuan-Hsin Chen wrote:
>> From: Yuan-Hsin Chen <yuanlmm@gmail.com>
>>
>> Due to fusb300 controller modification, stall clear procedure should be
>> modified consistantly. This patch also fixes software bugs: only
>> enter IDMA_RESET when the condition matched and disable corresponding
>> PRD interrupt in IDMA_RESET.
>>
>>
>> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>
> I have been trying to understand if this is a bug fix or if it can wait
> until v3.10.

There are a software bug fix and two corresponding fixes to hw register
 modification in the patch. Should it wait until v3.10?
>
> Also, according to your commit log, it seems like this patch is doing
> more than one thing, which is really frowned upon. Please split it up
> into separate logically self-contained changes. While doing that, make
> sure that your commit log explains the problem and the solution very
> well. Saying that because of a controller modification you need to
> change stall clear consistently isn't enough.

I will split it up and explain more clearly.
Thanks.
>
> Don't forget to mention how and with which platforms you tested.
>
> --
> balbi
