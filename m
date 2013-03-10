Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab3CJMLP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:11:15 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:53652 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3CJMLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:11:10 -0400
Message-ID: <513C7858.70401@suse.cz>
Date: Sun, 10 Mar 2013 13:11:04 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at drivers/tty/tty_buffer.c:428 flush_to_ldisc
References: <1362915489.1220.8.camel@localhost.localdomain>
In-Reply-To: <1362915489.1220.8.camel@localhost.localdomain>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2013 12:38 PM, Thomas Meyer wrote:
> [25693.253108] ------------[ cut here ]------------
> [25693.253117] WARNING: at drivers/tty/tty_buffer.c:428 flush_to_ldisc+0x162/0x170()
> [25693.253118] Hardware name: Aspire 1810T
> [25693.253119] tty is NULL

Yeah, thanks. I sent a patch to disable that warning completely:
https://lkml.org/lkml/2013/2/27/244

-- 
js
suse labs
