Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3C3PSH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 11:18:07 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51502 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab3C3PSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 11:18:05 -0400
Date: Sat, 30 Mar 2013 08:18:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frankie Lin <frankiefrankie.lin@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, open <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] TTY Fix NULL pointer error in tty_wakeup
Message-ID: <20130330151801.GA16237@kroah.com>
References: <1364630323-3078-1-git-send-email-frankiefrankie.lin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364630323-3078-1-git-send-email-frankiefrankie.lin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 03:58:43PM +0800, Frankie Lin wrote:
> When calling tty_wakeup and the parameter is NULL,the oops will happen.

Who is calling that function with NULL?  Shouldn't that be fixed
instead?

thanks,

greg k-h
