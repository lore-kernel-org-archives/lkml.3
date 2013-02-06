Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab3BFRt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:49:56 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:35791 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3BFRty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:49:54 -0500
Date: Wed, 6 Feb 2013 09:49:52 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] tty: metag_da: Add metag DA TTY driver
Message-ID: <20130206174952.GA1292@kroah.com>
References: <1360161902-25329-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360161902-25329-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 02:45:00PM +0000, James Hogan wrote:
> Greg: is it okay to take this into your tty tree as it depends on Jiri's
> tty_flip/tty_port changes? It won't get built until the arch/metag tree
> comes along and defines the METAG_DA Kconfig symbol.

Sure, I'll pick it up and push it to Linus for 3.9-rc1.

thanks,

greg k-h
