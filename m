Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3F3RX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 13:23:28 -0400
Received: from mta41.charter.net ([216.33.127.83]:39437 "EHLO
	mta41.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3F3RXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 13:23:22 -0400
X-Authority-Analysis: v=2.0 cv=foeE/yEf c=1 sm=1
 a=NeBweSrFeIqEG5ng+mIGTA==:17 a=01NHlALvFY8A:10 a=yUnIBFQkZM0A:10
 a=8nJEP1OIZ-IA:10 a=hOpmn2quAAAA:8 a=ag1SF4gXAAAA:8 a=VwQbUJbxAAAA:8
 a=fxJcL_dCAAAA:8 a=x-9bQdMcyRI0uP9GfCQA:9 a=wPNLvfGTeEIA:10 a=hUswqBWy9Q8A:10
 a=1TSTQ8KKaH4A:10 a=NeBweSrFeIqEG5ng+mIGTA==:117
X-Auth-id: cmFjb3JiaW4yMDEwQGNoYXJ0ZXIubmV0
Message-ID: <51D06989.7040805@charter.net>
Date: Sun, 30 Jun 2013 12:23:21 -0500
From: Richard Corbin <racorbin2010@charter.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: A Bug in 3.9.8
References: <51CF572F.3040400@charter.net> <20130630161105.GA4213@kroah.com>
In-Reply-To: <20130630161105.GA4213@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many Thanks and my apologies.


Richard Corbin
25532 Southwind Rd.
Warrenton, MO 63383
racorbin2010@charter.net



-------- Original Message --------
*Subject:* 	Re: A Bug in 3.9.8
*Date:* 	Sun 06/30/2013 at 11:11 AM
*From:* 	Greg KH <gregkh@linuxfoundation.org>
*To: * 	Richard Corbin <racorbin2010@charter.net>
*CC: * 	stable@vger.kernel.org, linux-kernel@vger.kernel.org

> On Sat, Jun 29, 2013 at 04:52:47PM -0500, Richard Corbin wrote:
>> Folks:
>>
>> I sent the indented text to gregkh@linuxfoundation.org,
>> inappropriately as I suspected. I got a polite automated response
>> suggesting alternate destinations for my email. To my non-technical
>> eyes, your addresses seemed most appropriate.
>>
>>      "Mr. Kroah-Hartman,
>>
>>      "Excuse me for bothering you, but I do not know where to report
>> my problem and I found your name in
>> http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.9.8-saucy/BUILD.LOG.
> My name is there because it's the first commit, for some strange reason
> the Ubuntu build logs this, but I have nothing to do with their kernel
> builds.
>
>>      "I am running Linux Mint KDE v15, but I like to run the latest
>> kernel. I have never had a problem before installing the latest
>> "general release" kernel from
>> http://kernel.ubuntu.com/~kernel-ppa/mainline/ until yesterday.
>>
>>      "After I installed v3.9.8-saucy, the system could no longer
>> "read" cpu usage of my quad-core Intel  q6600. Conky, "top", "mpstat
>> -P ALL" all show ZERO CPU usage. Everything else is fine; it is just
>> the reporting that is busted.
>>
>>      "If you are the wrong person and cannot forward to correct
>> destination, then I am sorry for wasting your time."
>>
>> I neglected to write that when I rebooted the identical system using
>> v3.9.7-saucy as the kernel, the CPU usage for each core was
>> registering non-zero values when appropriate as usual.
> As this is a Ubuntu-specific kernel, I suggest filing a bug in the
> Ubuntu bug tracking tool to help resolve this, ther's not much we in the
> community can do about this, sorry.
>
> best of luck,
>
> greg k-h
>

