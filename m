Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaC0I0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:26:17 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:52998 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaC0I0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:26:14 -0400
Message-ID: <5333E095.10008@ahsoftware.de>
Date: Thu, 27 Mar 2014 09:25:57 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Levente Kurusa <levex@linux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] initramfs: print error and shell out for unsupported
 content
References: <CAAsK9AEeobOG1j6NHUoqkZaZ5h8GGK_fL+gyh9MhSvguQjyU_w@mail.gmail.com>	<1395352845-7435-1-git-send-email-holler@ahsoftware.de>	<20140321140305.a3679620aa25132a3b75a404@linux-foundation.org>	<532CC215.1000107@ahsoftware.de>	<20140321155517.51af1b28fe32656fb7506f97@linux-foundation.org>	<532CC625.7020509@ahsoftware.de>	<53334393.5050008@ahsoftware.de> <CAAsK9AG85HmHYgVL=19hYtTF+AiaZHX0hhg8V3Q-+WfVi_jzCw@mail.gmail.com> <53334CB7.9020107@ahsoftware.de> <533356AD.7080809@ahsoftware.de>
In-Reply-To: <533356AD.7080809@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.03.2014 23:37, schrieb Alexander Holler:
> Am 26.03.2014 22:55, schrieb Alexander Holler:
>> Am 26.03.2014 22:38, schrieb Levente Kurusa:

>>> This is walkable but probably not worth the effort. Besides, why would
>>> anyone want to put spaces, colons and arbitrary characters to filenames
>>> in the initramfs?
>
> I've already suggest an example for that. If you have a machine with
> bluetooth, look at /var/lib/bluetooth and you will discover directories
> with colons. So, guess what happens if you want to have (preset)
> link-keys in an initramfs to avoid an otherwise necessary pairing.
>
> And spaces in filenames are used by a lot of people for various reasons.
> And you might wonder, but there exists software one might want to use in
> an initramfs which needs some file(s) with an hardcoded name wich
> contains spaces.

Just that this problem exists at least since the dawn of git doesn't 
mean nobody has suffert through it.

E.g. I know the bug with colons since several years, but just feared to 
post a simple patch (for legitimate reasons as this thread shows).

Alexander Holler

