Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3C1XDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 19:03:47 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37570 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3C1XDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 19:03:45 -0400
Date: Thu, 28 Mar 2013 16:03:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_dw: add support for clk api
Message-ID: <20130328230342.GA24556@kroah.com>
References: <1364387748-13015-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364387748-13015-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 01:35:48PM +0100, Maxime Ripard wrote:
> From: Emilio López <emilio@elopez.com.ar>
> 
> This commit implements support for using the clk api; this lets us use
> the "clocks" property with device tree, instead of having to use
> clock-frequency.
> 
> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> ---

Why aren't you signing off on this patch as well?

greg k-h
