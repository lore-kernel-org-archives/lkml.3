Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab3J1PSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:18:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab3J1PSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:18:43 -0400
Date: Mon, 28 Oct 2013 08:20:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: RUC_SoftSec <rucsoftsec@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Wang YanQing <udknight@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: Add NULL check to return value of kzalloc()
Message-ID: <20131028152034.GA9437@kroah.com>
References: <1382938072-14769-1-git-send-email-rucsoftsec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382938072-14769-1-git-send-email-rucsoftsec@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 01:27:52PM +0800, RUC_SoftSec wrote:
> Function kzalloc() may return a NULL pointer, it should be checked against NULL before used.
> This bug is found by a static analysis tool developed by RUC_SoftSec, supported by China.X.Orion.
> 
> Signed-off-by: RUC_SoftSec <rucsoftsec@gmail.com>

I've already explained why I can not accept patches like this, consider
all of them that you sent now deleted from my inbox.

greg k-h
