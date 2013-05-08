Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab3EHCAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:00:19 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:51486 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab3EHCAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:00:17 -0400
Date: Wed, 8 May 2013 10:00:08 +0800
From: Wang YanQing <udknight@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]TTY: Fix tty can't be restarted by TCXONC ioctl request
Message-ID: <20130508020008.GA2111@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Peter Hurley <peter@hurleysoftware.com>, gregkh@linuxfoundation.org,
	jslaby@suse.cz, linux-kernel@vger.kernel.org
References: <20130507184734.GA2459@udknight>
 <518968FD.4030402@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518968FD.4030402@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 04:50:05PM -0400, Peter Hurley wrote:
> This should be fixed in n_tty_set_termios() instead of fixing userspace
> workarounds.

Sorry, I misuse the word "workaround", emacs just do the right thing I think.
But your suggestion maybe import policy.

> The problem occurs when the tty has been stopped with STOP_CHAR(tty) and then
> termios is changed so that START_CHAR(tty) is subsequently ignored
> (in the reported case, I_IXON(tty) is cleared).
> 
That's right.

Thanks.
