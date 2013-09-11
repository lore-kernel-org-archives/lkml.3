Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3IKQAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:00:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab3IKQAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:00:17 -0400
Date: Wed, 11 Sep 2013 09:00:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [117/251] radeon kms: do not flush uninitialized hotplug work
Message-ID: <20130911160016.GC24542@kroah.com>
References: <20130911042707.738353451@goodmis.org>
 <20130911042911.752089217@goodmis.org>
 <20130911090648.GA2271@swordfish.minsk.epam.com>
 <20130911083741.6b2783b2@gandalf.local.home>
 <20130911143629.GB2209@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911143629.GB2209@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 05:36:29PM +0300, Sergey Senozhatsky wrote:
> This one on top of stable 3.6.11 git.

What do you mean by this?

confused,

greg k-h
