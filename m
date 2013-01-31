Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab3AaQNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:13:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:38704 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab3AaQNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:13:47 -0500
Date: Thu, 31 Jan 2013 17:15:43 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] firmware: Make user-mode helper optional (v5)
Message-ID: <20130131161543.GA25700@kroah.com>
References: <1359627237-7069-1-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359627237-7069-1-git-send-email-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 11:13:53AM +0100, Takashi Iwai wrote:
> Hi,
> 
> this is a series of revised patches for making the user-mode helper
> call in the firmware loader optional.  Hopefully all things settled
> down now.
> 
> v4->v5: fix invalid call of usermodehelper_unlock()

Yeah!  I was working on doing just this right as you sent this series
in.  I'll take your patches instead of mine, you did all of the hard
work here, thanks :)

Ming, any objection to me taking them?

thanksm,

greg k-h
