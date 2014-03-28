Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbaC1XTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 19:19:50 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59737 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbaC1XTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 19:19:48 -0400
X-Sasl-enc: eJEJAvRlWzAy6aTSpsyFuduBU9ZUdE1h/Hyi3sYgunOm 1396048786
Message-ID: <53360393.2030108@imap.cc>
Date: Sat, 29 Mar 2014 00:19:47 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Karsten Keil <isdn@linux-pingi.de>, tglx@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] isdn: replace del_timer by del_timer_sync
References: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr> <1395869625-15209-2-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1395869625-15209-2-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 26.03.2014 22:33, schrieb Julia Lawall:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Use del_timer_sync to ensure that the timer is stopped on all CPUs
> before the driver exists.

Surely you meant "exits"?

Regards,
Tilman

- -- 
Tilman Schmidt                              E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM2A5IACgkQQ3+did9BuFtuMACfarliJdOkqLmJJvRqbcM5eCFd
CWwAn3FuQ+juOeo2EgM8e1JBTjlHhG3o
=a90K
-----END PGP SIGNATURE-----
