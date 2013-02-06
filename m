Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3BFNyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:54:09 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:53168 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3BFNyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:54:03 -0500
Message-ID: <51126078.2050504@suse.cz>
Date: Wed, 06 Feb 2013 14:54:00 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@suse.de>
CC: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <20130129202848.GE25415@pd.tnic> <3066730.6MVSAfNyye@vostro.rjw.lan> <20130131131034.GF4926@pd.tnic> <2293454.v8QRHr8txR@vostro.rjw.lan>
In-Reply-To: <2293454.v8QRHr8txR@vostro.rjw.lan>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2013 12:04 AM, Rafael J. Wysocki wrote:
> On Thursday, January 31, 2013 02:10:34 PM Borislav Petkov wrote:
>> On Thu, Jan 31, 2013 at 02:12:58PM +0100, Rafael J. Wysocki wrote:
>>> Yes, there are two bugs in e1000e, it appears. Konstantin's
>>> patch [2/5] fixes one of them, but the other one has to be fixed
>>> differently.
>>>
>>> Boris, would you be able to test a couple of e1000e patches for me?
>>
>> Sure, send them on. You can add 2/5 in the mix too.
> 
> There you go.
> 
> The [2/5] is at: https://patchwork.kernel.org/patch/2001211/
> 
> The other two are attached.  I suppose the ordering doesn't matter.

Just a side question, are these going to be merged some time soon? I
don't even see them in -next and I would like to backport them to
opensuse as they affect also 3.7...

-- 
js
suse labs
