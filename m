Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3EHNQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:16:42 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58672 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3EHNQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:16:41 -0400
Date: Wed, 8 May 2013 21:16:24 +0800
From: Wang YanQing <udknight@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]TTY: Fix tty can't be restarted by TCXONC ioctl request
Message-ID: <20130508131624.GA1938@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
	linux-kernel@vger.kernel.org
References: <20130507184734.GA2459@udknight>
 <20130507185800.GA10713@kroah.com>
 <20130508015545.GA1937@udknight>
 <20130508020200.GA15695@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508020200.GA15695@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 07:02:00PM -0700, Greg KH wrote:
> What about Peter's comments on this patch?
> 
Peter's comments will import policy,

I means we should let userspace to decide whether
and when to restart tty with the mechanism of TCXONC
instead of restart tty accidental when make n_tty_set_termios
call.

Thanks.
