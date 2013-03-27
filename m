Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3C0TqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:46:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43076 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3C0TqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:46:18 -0400
Date: Wed, 27 Mar 2013 19:46:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Hans de Bruin <jmdebruin@xmsnet.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86, vm86: fix VM86 syscalls: use asmlinkage calling
 convention
Message-ID: <20130327194614.GA21522@ZenIV.linux.org.uk>
References: <514F6DF9.1070602@xmsnet.nl>
 <1364332526.8559.140661209554365.0203B0A4@webmail.messagingengine.com>
 <5152F321.7020604@xmsnet.nl>
 <1364412662.12858.140661209988437.506AD50B@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364412662.12858.140661209988437.506AD50B@webmail.messagingengine.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 08:31:02PM +0100, Alexander van Heukelum wrote:
> Hi Al,
> 
> Hans de Bruin found a regression due to one of your changes. I asked him to test a fix and he reported back that it worked. (Thanks!) Can you see if you agree with the fix? Patch is attached due to webmail...

Use SYSCALL_DEFINE{1,2} for vm86_old and vm86, please.
