Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab3FPJcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 05:32:15 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:32840 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab3FPJcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 05:32:13 -0400
Date: Sun, 16 Jun 2013 11:32:07 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Peter Korsgaard <jacmet@uclibc.org>,
        Cody Schafer <cody@linux.vnet.ibm.com>,
        Benjamin Poirier <bpoirier@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC][PATCH] kconfig: Fix defconfig when one choice menu selects
 options that another choice menu depends on
Message-ID: <20130616093207.GA3495@free.fr>
References: <1370576226-7597-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1370576226-7597-1-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve, All,

On 2013-06-06 20:37 -0700, Arve Hjønnevåg spake thusly:
> The defconfig and Kconfig combination below, which is based on 3.10-rc4
> Kconfigs, resulted in several options getting set to "m" instead of "y".
[--SNIP--]
> Signed-off-by: Arve Hjønnevåg <arve@android.com>

I've taken this in my tree, and will push to Michal for the next merge
window:
    https://www.gitorious.org/linux-kconfig/linux-kconfig/ yem-kconfig-for-next

Thank you!

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
