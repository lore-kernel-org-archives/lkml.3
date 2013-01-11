Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3AKMte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:49:34 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:40379 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3AKMtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:49:32 -0500
Message-ID: <50F00A59.70808@gmail.com>
Date: Fri, 11 Jan 2013 13:49:29 +0100
From: Adrian Byszuk <adrian.byszuk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Sujith Manoharan <sujith@msujith.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: BUG: kernel panic on Dell Vostro 3560 when plugging in AC adapter
References: <50ED98AA.1090304@gmail.com> <20130109170119.GA17840@liondog.tnic> <50EDB070.9020908@gmail.com> <20130109181520.GB17840@liondog.tnic> <50EE9F24.8010908@gmail.com> <20130110113511.GB23008@liondog.tnic> <50EECA0B.2050407@gmail.com> <50EEF8A9.5070406@gmail.com> <20719.47186.830126.689552@gargle.gargle.HOWL> <50EFF6B9.5090303@gmail.com> <20130111114648.GA10751@liondog.tnic>
In-Reply-To: <20130111114648.GA10751@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/13 12:46, Borislav Petkov wrote:
> On Fri, Jan 11, 2013 at 12:25:45PM +0100, Adrian Byszuk wrote:
>> Aaaah... yes, looks like this is it. I'll wait for the 3.7.2 and if it
>> isn't fixed then I'll mail here again.
> 
> Sorry, I just noticed I had email trouble and you've probably didn't see
> my email yet - this patch is not in the 3.7.2 lineup for some reason so
> you should cherrypick it ontop of 3.7.1 and test.
> 
> Thanks.
> 

I've got both of your emails.
I've just tested this patch, and so far things seem to work flawlessly.
So I would strongly recommend it for the stable series :-)

Thank you for your help!

Adrian
