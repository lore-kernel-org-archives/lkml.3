Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab3GPA0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:26:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46857 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab3GPA0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:26:12 -0400
Message-ID: <51E4930F.9030602@zytor.com>
Date: Mon, 15 Jul 2013 17:25:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Guenter Roeck <linux@roeck-us.net>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
References: <1373916476.2748.69.camel@dabdike> <20130715201943.GA22131@roeck-us.net> <1373925868.24167.35.camel@shinybook.infradead.org> <20130715220730.GA23916@roeck-us.net> <51E479D0.4040304@zytor.com> <20130715232209.GB24650@roeck-us.net> <51E49036.5000901@zytor.com> <20130716002128.GA9278@kroah.com>
In-Reply-To: <20130716002128.GA9278@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 05:21 PM, Greg KH wrote:
>>
>> However, it doesn't seem to happen too often, but it does underscore the
>> need for a maintainer to be able to *retroactively* NAK a patch for
>> stable, if it is uncovered that it isn't appropriate after all.
> 
> I give maintainers 2 different chances to NAK a patch, and if they miss
> those, I can also easily revert a patch that got applied and do a new
> release, which I have done in the past.
> 

Yes, it doesn't actually seem to be a problem in practice.

In other words, the current system seems to work well, and unless
someone wants to show cases where it doesn't work I don't see a reason
to switch it...

	-hpa


