Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab3EGHDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:03:01 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:58451 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3EGHC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:02:59 -0400
Message-ID: <5188A739.8080309@suse.cz>
Date: Tue, 07 May 2013 09:03:21 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [094/126] TTY: fix atime/mtime regression
References: <20130507035712.909872333@goodmis.org> <20130507035856.682670331@goodmis.org>
In-Reply-To: <20130507035856.682670331@goodmis.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 05:58 AM, Steven Rostedt wrote:
> 3.6.11.3 stable review patch.
> If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jiri Slaby <jslaby@suse.cz>
> 
> [ Upstream commit 37b7f3c76595e23257f61bd80b223de8658617ee ]

Hi, you also want this one:
commit b0b885657b6c8ef63a46bc9299b2a7715d19acde
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 1 07:32:21 2013 -0700

    tty: fix up atime/mtime mess, take three


regards,
-- 
js
suse labs
