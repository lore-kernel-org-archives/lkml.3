Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab3C0PhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:37:21 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:50426 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3C0PhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdY=UXZrRwuWp1JTePG71C=pAPc26kWWRqPZv_qZHc-_bg@mail.gmail.com>
References: <20130327061114.3356.57465.sendpatchset@w520>
	<CACRpkdY=UXZrRwuWp1JTePG71C=pAPc26kWWRqPZv_qZHc-_bg@mail.gmail.com>
Date: Thu, 28 Mar 2013 00:37:13 +0900
Message-ID: <CANqRtoShQMCS3Cx+r9i1k7fWp6=TgqCX8h3d10qozr4Mt_5wQA@mail.gmail.com>
Subject: Re: [PATCH] gpio: em: Make use of devm functions
From: Magnus Damm <magnus.damm@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        horms@verge.net.au, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 12:01 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Wed, Mar 27, 2013 at 7:11 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> From: Magnus Damm <damm@opensource.se>
>>
>> Update the Emma Mobile GPIO driver to make use of devm
>> functions. This simplifies the error handling and makes
>> the code more compact.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>
> I guess this is a resend. IIRC I just applied it some hours ago...

Yep, correct. Thanks for your help!

Now if I only could find time to marry the gpio-em.c driver with sh-pfc.c..

/ magnus
