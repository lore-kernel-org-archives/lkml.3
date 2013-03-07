Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676Ab3CGTH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 14:07:29 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:44732 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3CGTH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 14:07:27 -0500
Message-ID: <5138E56B.6090308@suse.cz>
Date: Thu, 07 Mar 2013 20:07:23 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 8250.nr_uarts broken in 3.7
References: <20130307185642.GF13719@hansolo.jdub.homelinux.org>
In-Reply-To: <20130307185642.GF13719@hansolo.jdub.homelinux.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 07:56 PM, Josh Boyer wrote:
> commit 835d844d1a28efba81d5aca7385e24c29d3a6db2
> Author: Sean Young <sean@mess.org>
> Date:   Fri Sep 7 19:06:23 2012 +0100
> 
>     8250_pnp: do pnp probe before legacy probe
> 
> but that is simply moving code around.

Hi, not quite. Does it still happen when you revert that one on the top
of 3.[789]*?

> I ran the same test on a 3.9-rc1 kernel and it isn't being picked up
> there either.  Before I go off and do a bisect to track this down, has
> anyone else seen or heard of this no longer working?

I haven't heard of that yet.

thanks,
-- 
js
suse labs
