Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaDQLtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:49:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbaDQLtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:49:40 -0400
Date: Thu, 17 Apr 2014 13:49:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jamie Lentin <jm@lentin.co.uk>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] hid: Add custom driver for Lenovo ThinkPad Compact
 Bluetooth Keyboard
In-Reply-To: <1397732098-7853-1-git-send-email-jm@lentin.co.uk>
Message-ID: <alpine.LNX.2.00.1404171344480.15539@pobox.suse.cz>
References: <1397732098-7853-1-git-send-email-jm@lentin.co.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014, Jamie Lentin wrote:

> This keyboard requires some custom mappings for all keys to be
> available, and the Fn-lock toggle needs to be controlled in software.
> 
> Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
> ---
> Apologies for nagging, but anyone got any feedback on this? I don't
> think there's anything massively contentious, but hasn't been picked up
> by anyone yet.

I've been buried in a lot of other things (travel, merge window, etc.), so 
this is still sitting in my queue that has to be processed (and hasn't 
been forgotten).

-- 
Jiri Kosina
SUSE Labs
