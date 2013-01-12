Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab3ALJKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 04:10:36 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39010 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab3ALJK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 04:10:29 -0500
Message-ID: <50F12882.2090508@suse.cz>
Date: Sat, 12 Jan 2013 10:10:26 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tty: cleanup the panic message
References: <1357963283-20119-1-git-send-email-dinggnu@gmail.com>
In-Reply-To: <1357963283-20119-1-git-send-email-dinggnu@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2013 05:01 AM, Cong Ding wrote:
> the "\n" in panic message is excess, so we remove it in tty/pty.c as what it
> is used in other places.

All three are OK. Thanks.

-- 
js
suse labs
