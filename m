Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaG0D6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 23:58:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64011 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaG0D6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 23:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <1406363096.5091.132.camel@marge.simpson.net>
References: <CAPDOMVhgNzCMAr_XxVPec=p_hBP4piKLVzw_1O+tUFOxNzzQ0g@mail.gmail.com>
	<1406363096.5091.132.camel@marge.simpson.net>
Date: Sat, 26 Jul 2014 23:58:11 -0400
Message-ID: <CAPDOMVioXBSRFBZrTJKj9MqYOE7oDMkvZS-pDQN3QF7inzGoxg@mail.gmail.com>
Subject: Re: Kernel 3.16-rc6 Bug with Sound?
From: Nick Krause <xerofoify@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 4:24 AM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
> On Fri, 2014-07-25 at 18:57 -0400, Nick Krause wrote:
>> Hey guys after compiling and running the kernel in the subject line I
>> get no sound
>> and a message of no sound codec could be found. I am new so this may be
>> a  missed needed config for sound or it's a bug. I am attaching my config
>> to help you guys out :).
>
> (peek)  Ah.. ok, thanks for the report.
>
> -Mike
>
Mike,
Missed config but I did find a bug with my sound.
Cheers Nick
