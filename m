Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbbATRUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:20:53 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:38114 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbbATRUw (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:20:52 -0500
Message-ID: <54BE8E71.3080101@hurleysoftware.com>
Date: Tue, 20 Jan 2015 12:20:49 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Howard Chu <hyc@symas.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] n_tty: Remove LINEMODE support
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com> <54BC3771.7030204@symas.com> <54BC5EC7.1090202@hurleysoftware.com> <54BCFC94.1040605@symas.com> <54BD1B53.9030901@hurleysoftware.com> <54BD328F.9090208@symas.com> <54BD567C.8070200@hurleysoftware.com> <54BD69A4.4090705@symas.com> <54BE6BD9.4050403@hurleysoftware.com>
In-Reply-To: <54BE6BD9.4050403@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 09:53 AM, Peter Hurley wrote:
> On 01/19/2015 03:31 PM, Howard Chu wrote:
>> Peter Hurley wrote:
>>> Ok.
>>> I might see if I can get telnet + a revised kernel interface to work together; I'll
>>> let you know if this works out.
>>
>> The patch here https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=585527#20 still applies cleanly to current Ubuntu netkit-telnet source and works.
> 
> Aw snap. I just quickly glanced at the patch and source, and assumed
> that the 4 year old patch had been applied.
> 
>> You'll have to use a dumb shell to see any effect.
> 
> I'm testing it now.

Yeah, canonical read() does not behave as it should if EXTPROC
is enabled; it's returning both multiple lines and unterminated lines.

Regards,
Peter Hurley


