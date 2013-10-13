Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3JMVtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 17:49:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab3JMVto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 17:49:44 -0400
Date: Sun, 13 Oct 2013 14:50:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [ 34/48] kernel/kmod.c: check for NULL in
 call_usermodehelper_exec()
Message-ID: <20131013215040.GA16112@kroah.com>
References: <20131011193637.253208688@linuxfoundation.org>
 <20131011193640.934535503@linuxfoundation.org>
 <201310120731.HAF30700.OFLOtMJQSFHFOV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310120731.HAF30700.OFLOtMJQSFHFOV@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 07:36:06AM +0900, Tetsuo Handa wrote:
> Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> 3.4-stable doesn't need this patch because commit 264b83c07a84
> ("usermodehelper: check subprocess_info->path != NULL") already fixed it.

Thanks for pointing this out for 3.0, 3.4, and 3.10, I totally got it
wrong there, despite you telling me this before.  I've now dropped it
from those three kernels.

thanks again,

greg k-h
