Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3BEPPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:15:46 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34731 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3BEPPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:15:44 -0500
Message-ID: <5111221D.1080509@suse.cz>
Date: Tue, 05 Feb 2013 16:15:41 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] tty: metag_da: fix flipping after tty changes
References: <1360075250-21970-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1360075250-21970-1-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 03:40 PM, James Hogan wrote:
> The first patch fixes up tty/metag_da after Jiri's changes, "TTY: switch
> tty_flip_buffer_push" and "TTY: convert more flipping functions",
> switched tty_flip_buffer_push() and tty_prepare_flip_string() to take
> tty_port rather than a tty_struct.
> 
> The second just refactors slightly as a result of it.
> 
> How is this sort of thing usually handled? I suppose either I squash it
> into the original driver and base it on tty-next, move it into tty-next,
> or just fix it up afterwards?
> 
> James Hogan (2):
>   tty: metag_da: update flip functions to use tty_port
>   tty: metag_da: avoid getting tty kref in dashtty_timer()

They both look good. You can add my:
Acked-by: Jiri Slaby <jslaby@suse.cz>
if you want.

thanks,
-- 
js
suse labs
