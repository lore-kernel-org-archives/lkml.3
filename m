Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaBIViZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:38:25 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751707AbaBIViY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:38:24 -0500
Message-ID: <52F7F54B.3050602@nod.at>
Date: Sun, 09 Feb 2014 22:38:19 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Paul Bolle <pebolle@tiscali.nl>
CC: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
References: <1391971686-9517-1-git-send-email-richard@nod.at>	 <1391971686-9517-25-git-send-email-richard@nod.at> <1391974709.25855.3.camel@x220> <52F7DF51.8000507@nod.at> <52F7F486.7040003@roeck-us.net>
In-Reply-To: <52F7F486.7040003@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.02.2014 22:35, schrieb Guenter Roeck:
> I could understand if you would replace DEPRECATED with BROKEN,
> but causing a potentially large number of broken builds and
> then leave it to others to clean up the resulting mess doesn't
> make any sense to me and should, in my opinion, be rejected.

Currently the mess is hidden by bad Kconfig dependencies.
We have to face it. :)

Of course, if the maintainer wants me or Paul to remove the resulting
mess to I'm fine with that...

Thanks,
//richard
