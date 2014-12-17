Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaLQNLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:11:30 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:62386 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaLQNL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:11:29 -0500
Message-ID: <549180FE.1020805@acm.org>
Date: Wed, 17 Dec 2014 07:11:26 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Convert Functions to Slabs in ipmi_msghandler.c
References: <54907B07.8090906@gmail.com>
In-Reply-To: <54907B07.8090906@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 12:33 PM, nick wrote:
> Greetings Corey,
> You stated in a TODO that someone needs to convert some functions to slabs. Unfortunately, I am unsure of all the functions you wish to convert to slabs in this file, as I can only use one or two that need to be converted from
> my reading of the functions below this TODO.

I'm not sure this is very important (which is why it hasn't been done). 
There can't be more than a few IPMI messages allocated at any one time,
so a slab would probably be a waste.  I'm going to remove that FIXME.

-corey
