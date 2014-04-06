Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaDFVH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 17:07:58 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:35235 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaDFVHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 17:07:55 -0400
Message-ID: <5341C22A.1050907@lwfinger.net>
Date: Sun, 06 Apr 2014 16:07:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Randy Dunlap <rdunlap@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig circular dependency question
References: <5341AFC7.1070001@lwfinger.net> <5341B999.3050206@infradead.org> <1396817575.4886.23.camel@x220>
In-Reply-To: <1396817575.4886.23.camel@x220>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2014 03:52 PM, Paul Bolle wrote:
> On Sun, 2014-04-06 at 13:31 -0700, Randy Dunlap wrote:
>> and/or changing MOUSE_APPLETOUCH to depend on USB instead of select it?
>
> MOUSE_APPLETOUCH selects USB and depends on USB_ARCH_HAS_HCD. That's
> actually quite a common pattern.
>
> But what is the purpose of USB_ARCH_HAS_HCD? It is set by default if
> USB_SUPPORT is set. And USB depends on it, but since USB also depends on
> USB_SUPPORT that seems superfluous.
>
> My slow day continues, because I find this hard to grok.

As you have seen in my reply to Randy, this appears to arise from violating one 
of the edicts of Linus that says that no configuration variable should select a 
subsystem. Of course, one could argue that RFKILL is also a subsystem, and that 
R8723AU should depend on it rather that selecting it.

My day also seems to be slowing. :)

Larry


