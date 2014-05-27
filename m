Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaE0Qiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:38:50 -0400
Received: from www.meduna.org ([92.240.244.38]:42398 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbaE0Qip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:38:45 -0400
Message-ID: <5384BF89.6010509@meduna.org>
Date: Tue, 27 May 2014 18:38:33 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: minyard@acm.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] arm: Set hardirq tracing to on when idling
References: <1401045323-7116-1-git-send-email-minyard@acm.org> <4559339.apo3Fd10HK@wuerfel>
In-Reply-To: <4559339.apo3Fd10HK@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-05-27 18:38:39
X-Connected-IP: 95.105.163.217:25275
X-Message-Linecount: 33
X-Body-Linecount: 18
X-Message-Size: 1226
X-Body-Size: 502
X-Received-Count: 1
X-Recipient-Count: 6
X-Local-Recipient-Count: 6
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.05.2014 11:26, Arnd Bergmann wrote:

> It seems like the right thing to do, I just don't understand
> why nobody hit this before.

Looks like this is what I did hit a month ago and
was not able to find the culprit:
http://www.spinics.net/lists/linux-rt-users/msg11656.html

> How exactly do you see this manifest? If it's clear
> that the trace comes from the idle function, maybe
> everybody just ignores it?

That was definitely what I did ;)

-- 
                                       Stano

