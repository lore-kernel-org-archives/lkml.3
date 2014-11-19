Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaKSMiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 07:38:25 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58796 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaKSMiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:38:24 -0500
MIME-Version: 1.0
In-Reply-To: <20141118113509.GA5346@pd.tnic>
References: <CANszf4jKHq-WY=+W=D3mFEnhL9=aZJ+-Mx7yp9kw=hYTi+gGFA@mail.gmail.com>
	<20141118113509.GA5346@pd.tnic>
Date: Wed, 19 Nov 2014 12:38:23 +0000
Message-ID: <CANszf4gkofGjOJ0Q4synw9w6W9W8LxkXNnGxQDpENtg58vhuvg@mail.gmail.com>
Subject: Re: mysterious udev segfault
From: Rogelio Serrano <rogelio.serrano@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 11:35 AM, Borislav Petkov <bp@alien8.de> wrote:
<snipped...>
>>
>> what are we seeing here? a jfs bug?
>
> Can you trigger with the upstream kernel too? i.e. remove the grsec
> stuff and retry.
>

I will do that. Im building a new kernel as right now.

> Btw, your mail is somehow cutoff on the right-hand side with those '$'
> chars...
>

Sorry about that. I just cut and pasted from mg in a narrow window.

<snipped...>
