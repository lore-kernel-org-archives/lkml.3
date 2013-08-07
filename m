Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309Ab3HGVEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:04:55 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:39684 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100Ab3HGVEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:04:54 -0400
Message-ID: <5202B674.7060005@linuxtoys.org>
Date: Wed, 07 Aug 2013 14:04:52 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <51FC5478.40500@linuxtoys.org> <51FC5A97.1090102@linuxtoys.org> <20130803223828.GA14611@kroah.com> <51FECDA6.5070001@linuxtoys.org> <20130804231958.GA25418@kroah.com> <52003958.7080103@linuxtoys.org> <20130806094604.GE27889@kroah.com> <520299AB.1020607@linuxtoys.org> <20130807192714.GC2708@kroah.com> <5202A284.7010106@linuxtoys.org> <20130807195427.GB4121@kroah.com>
In-Reply-To: <20130807195427.GB4121@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
>> 	cat /dev/proxyctrl   # what is the offset?
>> 	echo 2 > /dev/proxyctrl  # set offset to 2
>
> You have language bindings right there in bash for this api, what you
> are saying is that you don't want to write new syscall bindings for new
> languages, which is fine, don't do that, use the ones we already have
> for the vast number of different IPC types.

You are correct.  There very much is a protocol in use.  Just as
there is for setting ip_forward in /proc.  And from your previous
comment, it doesn't have to be ASCII.  It could be binary or XML.

>
> What is your specific requirements, I see you couch them in terms of
> what you have created, but none in terms of actual requirements with no
> specific implementation.

You are correct.  I have been giving them in terms of my goal. The
title still captures it: "a simple device to give daemons a /sys-like
interface".

I am not a kernel programmer.  I am an Electrical Engineer trying to
control a robot. So I don't know what you mean by "actual requirements"
or a "specific implementation".   If you point me at a working example
I'll be happy to try to provide these.

>
> And all of my other outstanding questions still remain, please address
> those as well.
Yes, understood.


Greg, once again let me thank you for your patience while dealing
with an EE (who probably needs more adult supervision).

thanks
Bob Smith

