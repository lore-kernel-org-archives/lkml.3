Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbbATTIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:08:38 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:37883 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbbATTIg (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:08:36 -0500
Message-ID: <54BEA7B2.2060708@hurleysoftware.com>
Date: Tue, 20 Jan 2015 14:08:34 -0500
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
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com> <54BC3771.7030204@symas.com> <54BC5EC7.1090202@hurleysoftware.com> <54BCFC94.1040605@symas.com> <54BD1B53.9030901@hurleysoftware.com> <54BD328F.9090208@symas.com> <54BD567C.8070200@hurleysoftware.com> <54BD5E54.3050909@symas.com> <54BE9840.8080808@hurleysoftware.com> <54BEA0E0.9080807@symas.com>
In-Reply-To: <54BEA0E0.9080807@symas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 01:39 PM, Howard Chu wrote:
> Peter Hurley wrote:
>> On 01/19/2015 02:43 PM, Howard Chu wrote:

[...]

>> So it's really back to the question of, does allowing EXTPROC for regular
>> ttys have _value_?
> 
> Does preventing it have value?

Not that that is the appropriate metric for kernel behavior,
but yes, preventing it has value: it significantly limits
the matrix required for testing.


> I like having the option of turning linemode on and off in a session, for debugging purposes if nothing else.

... which is just as achievable with a pty-specific ioctl.

Regards,
Peter Hurley
