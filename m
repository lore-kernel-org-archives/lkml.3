Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbaHZLcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:32:21 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36532 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaHZLcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:32:19 -0400
Message-ID: <53FC703F.8040501@suse.cz>
Date: Tue, 26 Aug 2014 13:32:15 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux@roeck-us.net, stable@vger.kernel.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/104] 3.12.27-stable review
References: <20140820195436.GA22902@roeck-us.net>	<53F5A864.5040206@suse.cz>	<53F8AFEE.2070608@roeck-us.net> <20140823.111035.1932350736810442438.davem@davemloft.net>
In-Reply-To: <20140823.111035.1932350736810442438.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/23/2014, 08:10 PM, David Miller wrote:
> From: Guenter Roeck <linux@roeck-us.net> Date: Sat, 23 Aug 2014
> 08:14:54 -0700
> 
>> On 08/21/2014 01:05 AM, Jiri Slaby wrote:
>>> The last three are just cosmetical in 3.12. And I do not
>>> immediately see in the rest, how they could improve the state.
>>> So I am going to remove the add-basic-validations patch from
>>> 3.12.
>>> 
>> 
>> Build and tests now look good.
> 
> I am hugely disappointed in this.

Yes, me too.

> This is why I really do all the backports for each -stable release 
> myself and I therefore really wish there was more thought put into 
> when these changes are placed into other trees.

If everybody were using the standard stable rules and did not
introduce a very special patches handling, we would have known what
stable trees should contain which patches. Not only that everybody is
confused about the special handling, but fixes for holes happened to
be missed in the special process several times as of now.

Furthermore, with the special handling and given subtree maintainers
provide backports only to selected stable trees, we have no way to
find out what should (not) be applied. Interpolation is only what
remains for us poor. (Leaving apart the great testing by the guys.)

> Almost all of those sparc64 memory management fixes should not go
> into anything before v3.13, because all of these fixes are in the
> context of the page tables encoding PMDs using the PTE layout.

Again, until subtree maintainers distribute their private local
knowledge somehow, we cannot know.

> If you're just forcing changes you see go into other -stable 
> submissions into your tree until they compile, and just hoping that
> a tester will catch any problems, you are absolutely doing it wrong
> and taking a large amount of value out of the -stable releases.

Actually, like it or not, this is exactly how all stable trees work
for specific scenarios/hardware. And then, we have the -rc's. If patch
authors do not bother to reply to the "patch added" mails despite they
know it is inappropriate, stable maintainers are short of
possibilities. Unless they are lucky, i.e. maintain a selected stable
tree, where a subtree maintainer provides them with a set of patches
for that tree.

thank you,
- -- 
js
suse labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/HA/AAoJEL0lsQQGtHBJAqwP/1iqbPpBmDVA82gijLprtJPt
O57ELwN9rOYsyfr702eXBm7UVW42T0AroxjAqoNx3MpoXfhXav49KaakAucMp7Sr
fF4AHUz1ztT//xjhplJqZ/ht3WxwkNfDzliQ31vjFLnMpRyeLHrJeQu4FEk+G5wM
2NLue5JdG2rHYxYxT5Rzwxg/n0eIXwSHCgt2DydmqhAiIkkigVkD+ajRMzpnmH2y
QErE3TN5PfKvs0tOjttZGuzCNKPdBfXacZyGe5HuXlg9LQ3TR+mqqWMIX3RUy6np
i/TCI0aC+MQCsS59YVQaea6GZBC9uFprS+G1lYRlf520Anslrdqw4XNt4m3Y9GdL
ptdUDTtp2b1bJQIC7PL+T9Nt8Wro1p3q0to1gEW4e8YJLYor0z5E9bDqPBXX/e+x
fZ9IQsbUa+OjUkjqF+Cp4FWiI5hPzbJBbITiiAhYMjwr5zyaO7dt1higccvaXaIj
9P3zzqpFgsVQcD6IUC9krW3wJ6Pgba+a9oj+AXwxffAvhHxaR2KSRCzfIMa7rcwk
Q+wPG31V781h1NHf0q0Wc/3AVacs9WrmGh+MWciUCJUvSQQ+4mTQIoehAGIzF86s
bljMaVQ1tf4aJpojQ1jltTBbckY2rhuDgs5u5fQDKQn+FKL/IMQ2NIr9xYYy54C0
MnOIE7FqoMFVJaMAWSC7
=ueH5
-----END PGP SIGNATURE-----
