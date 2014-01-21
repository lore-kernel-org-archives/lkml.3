Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaAUP6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:58:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:56271 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbaAUP6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:58:41 -0500
Message-ID: <52DE9938.6090804@windriver.com>
Date: Tue, 21 Jan 2014 10:58:48 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Aaro Koskinen <aaro.koskinen@iki.fi>
CC: <linux-kernel@vger.kernel.org>, <konstantin@linuxfoundation.org>
Subject: Re: 2.6.34.x longterm stable status
References: <20130805193210.GA1824@blackmetal.musicnaut.iki.fi> <20130808040723.GG12411@windriver.com> <52DE8DDD.108@zytor.com>
In-Reply-To: <52DE8DDD.108@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-21 10:10 AM, H. Peter Anvin wrote:
> On 08/07/2013 09:07 PM, Paul Gortmaker wrote:
>>>
>>> - Shouldn't the EOL status be mentioned in the www.kernel.org front page?
>>
>> It will be marked EOL at kernel.org when it is EOL.  Those that care
>> about it being EOL would have seen the message about it becoming EOL in
>> the previous 2.6.34.x release annoucement.
>>
> 
> Maybe it is time to check in on this?

Yes, Konstantin just ping'd me recently on this, and the final update will
be out for review within a week;  with a focus on just clear CVE like
fixes and hence a relatively smaller queue size (i.e. nothing like 200
patches etc.)

If you think it best to mark it EOL in advance of that last release,
rather than waiting for it to appear, I don't see that as a problem.

Paul.
--

> 
> I just noticed that this is now over a year since the last 2.6.34
> release, which lags the last 2.6.32 release by about five months.  I am
> asking because someone just queried me privately about the status of
> 2.6.34.  I'm worrying if people think that security patches are still
> being backported if in fact they aren't.
> 
> 	-hpa
> 
> 
