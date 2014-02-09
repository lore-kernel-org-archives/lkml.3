Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaBIUVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:21:39 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751607AbaBIUVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:21:37 -0500
Message-ID: <52F7E34E.3010509@nod.at>
Date: Sun, 09 Feb 2014 21:21:34 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
References: <1391971686-9517-1-git-send-email-richard@nod.at>		 <1391971686-9517-25-git-send-email-richard@nod.at>	 <1391974709.25855.3.camel@x220> <52F7DF51.8000507@nod.at> <1391976929.25855.22.camel@x220>
In-Reply-To: <1391976929.25855.22.camel@x220>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.02.2014 21:15, schrieb Paul Bolle:
> On Sun, 2014-02-09 at 21:04 +0100, Richard Weinberger wrote:
>> Am 09.02.2014 20:38, schrieb Paul Bolle:
>>> But now you've enabled a lot of stuff that, as far as I can tell, could
>>> not have been built since v2.6.39.
>>
>> This is by design. If the code does not build/work it needs to be fixed or removed.
> 
> If that was the design goal of this patch (and similar patches you've
> sent) it would have been proper to at least say a few words along those
> lines in the commit explanation.

I assumed that every kernel developer is aware of that fact that unreachable/dead code
should be removed.

That said, feel free to use my patch series as base for your work.
The series is only a by-product of some "real" work.

Thanks,
//richard
