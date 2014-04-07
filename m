Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaDGAbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 20:31:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbaDGAbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 20:31:12 -0400
Date: Sun, 6 Apr 2014 17:33:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Fabio Falzoi <fabio.falzoi84@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rts5139: fix coding style
Message-ID: <20140407003341.GA13365@kroah.com>
References: <1396824306-20343-1-git-send-email-fabio.falzoi84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396824306-20343-1-git-send-email-fabio.falzoi84@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 12:45:05AM +0200, Fabio Falzoi wrote:
> fix some coding style issues in rts51x.c (from rts5139 module)

What specific coding style issues did you fix here?

You need to be explicit, and if you do more than one type of change in
the same patch, it needs to be broken up into different patches.

Can you please resend this based on this?

thanks,

greg k-h
