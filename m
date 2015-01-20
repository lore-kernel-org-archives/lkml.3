Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbbATOxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:53:18 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45790 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbbATOxR (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:53:17 -0500
Message-ID: <54BE6BD9.4050403@hurleysoftware.com>
Date: Tue, 20 Jan 2015 09:53:13 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Howard Chu <hyc@symas.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] n_tty: Remove LINEMODE support
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com> <54BC3771.7030204@symas.com> <54BC5EC7.1090202@hurleysoftware.com> <54BCFC94.1040605@symas.com> <54BD1B53.9030901@hurleysoftware.com> <54BD328F.9090208@symas.com> <54BD567C.8070200@hurleysoftware.com> <54BD69A4.4090705@symas.com>
In-Reply-To: <54BD69A4.4090705@symas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 03:31 PM, Howard Chu wrote:
> Peter Hurley wrote:
>> Ok.
>> I might see if I can get telnet + a revised kernel interface to work together; I'll
>> let you know if this works out.
> 
> The patch here https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=585527#20 still applies cleanly to current Ubuntu netkit-telnet source and works.

Aw snap. I just quickly glanced at the patch and source, and assumed
that the 4 year old patch had been applied.

> You'll have to use a dumb shell to see any effect.

I'm testing it now.

Regards,
Peter Hurley


