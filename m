Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbaHEDlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 23:41:04 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61682 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaHEDWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 23:22:30 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E04DF3.40604@roeck-us.net>
Date: Mon, 04 Aug 2014 20:22:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [GIT PULL] hwmon updates for 3.17
References: <20140805022209.GA13813@roeck-us.net> <20140805131447.5cec84e5@canb.auug.org.au>
In-Reply-To: <20140805131447.5cec84e5@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 08:14 PM, Stephen Rothwell wrote:
> Hi Guenter,
>
> On Mon, 4 Aug 2014 19:22:09 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> Hi Linus,
>>
>> Please pull hwmon updates for Linux 3.17 from signed tag:
>>
>>      git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus
>
> This branch was rewritten (but not rebased) to add 5 commits at its
> start and 8 commits at its end since yesterday's linux-next.
>
Yes, the start because I missed to send a bunch of fixes to Linus last week because I was on vacation
and merged it all together, and the end because I missed to push out a bunch of patches for the same
reason. Everything did pass my test suite, though.

If that is a problem, let me know.

Guenter

