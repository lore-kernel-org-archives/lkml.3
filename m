Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277Ab3IDIWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:22:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab3IDIWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:22:51 -0400
Message-ID: <5226EDD4.9090300@suse.cz>
Date: Wed, 04 Sep 2013 10:22:44 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] kconfig: do not special-case 'MODULES' symbol
References: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr> <20130903211237.GA3681@free.fr>
In-Reply-To: <20130903211237.GA3681@free.fr>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 3.9.2013 23:12, Yann E. MORIN napsal(a):
> Doh... I forgot to send an intro mail first. Seems holidays really were
> a good break! :-)

:-)


> Anyway, this series might be a bit late to go in for 3.12, but it has
> previously been discussed with you and Sam.
> 
> If you feel it's too touchy for 3.12, then I believe it can easily wait
> for 3.13.
> 
> If you want it for 3.12, I can send a pull-request if that's easier for
> you.

Please send me a pull request regardless, so that the second commit's
changelog references the right commit id. I'll play with this and will
merge it into kbuild.git if there are no problems. It's two days into
the merge window, so no big deal (shh!).

Michal
