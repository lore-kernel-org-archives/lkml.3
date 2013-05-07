Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab3EGQkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:40:03 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:36923 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133Ab3EGQkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:40:01 -0400
Message-ID: <51892E5E.8090909@linaro.org>
Date: Tue, 07 May 2013 09:39:58 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>
CC: Arnd Bergmann <arnd@arndb.de>, tglx@linutronix.de,
        Jamie Iles <jamie@jamieiles.com>, dinguyen@altera.com, wd@denx.de,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: dw_apb_timer_of.c: remove parts that were picoxcell-specific
References: <20130426121433.GA16249@amd.pavel.ucw.cz> <201305061545.22587.arnd@arndb.de> <20130506155304.GA6645@amd.pavel.ucw.cz> <201305062324.17080.arnd@arndb.de> <20130507135752.GA3500@amd.pavel.ucw.cz>
In-Reply-To: <20130507135752.GA3500@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 06:57 AM, Pavel Machek wrote:
>>> So I guess it should go through the timekeeping tree...?
>> I would prefer that, but we can also take it through arm-soc, it doesn't
>> really matter.
> I see no response from timekeeping people... so if you could take it,
> that would be great.

I don't think the original patch ever made it to my inbox.

thanks
-john


