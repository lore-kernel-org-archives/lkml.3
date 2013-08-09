Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031345Ab3HIWUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:20:31 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:45387 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031204Ab3HIWUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:20:30 -0400
Message-ID: <52056B30.3020003@linuxtoys.org>
Date: Fri, 09 Aug 2013 15:20:32 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <20130804231958.GA25418@kroah.com> <52003958.7080103@linuxtoys.org> <20130806094604.GE27889@kroah.com> <520299AB.1020607@linuxtoys.org> <20130807192714.GC2708@kroah.com> <5202A284.7010106@linuxtoys.org> <20130807195427.GB4121@kroah.com> <5202B674.7060005@linuxtoys.org> <20130807213325.GB5373@kroah.com> <52040C3A.9090708@linuxtoys.org> <20130809215231.GA21756@kroah.com>
In-Reply-To: <20130809215231.GA21756@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> On Thu, Aug 08, 2013 at 02:23:06PM -0700, Bob Smith wrote:
>> Greg
>>      I'll reply again to this message but for now let me try
>> another explanation that does not mention sysfs, procfs, or
>> device drivers.   This is probably how I should have started.
>
> I fail to understand how you will use this code to write a "userspace
> device driver" at all.


I just sent a message that cover userspace drivers.
Basically, if you think userspace driver can exist, then
you probably need something like this proxy driver.

thanks
Bob Smith


