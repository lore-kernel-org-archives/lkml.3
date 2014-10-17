Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaJQIrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:47:10 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41546 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaJQIrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:47:07 -0400
Message-ID: <5440D781.1080308@suse.cz>
Date: Fri, 17 Oct 2014 10:46:57 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -next 05/10] tty: Document defunct ASYNC_* bits in uapi
 header
References: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com> <1413492867-20679-6-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1413492867-20679-6-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014, 10:54 PM, Peter Hurley wrote:
> Note the serial_struct flags for which the kernel ignores and performs
> no action. The flags cannot be removed since they form part of the
> userspace interface via the TIOCSSERIAL/TIOCGSERIAL ioctls.

Hello,

would it make sense to mark them deprecated somehow? At build time, or
at least warn in the serial core that "current->comm is using a
deprecated flag"_ratelimited()?

thanks,
-- 
js
suse labs
