Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3FAJED (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:04:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3FAJD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:03:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 11/15] iwlegacy: il_pm_ops is only provided for PM_SLEEP
Date: Sat, 01 Jun 2013 11:03:54 +0200
Message-ID: <1782157.poHidi6zEK@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CAN8TOE8Y_2RMSrgMw7KwML88_1VA=QcJwuuMKEZpZCF5_dAQ=w@mail.gmail.com>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de> <1370038972-2318779-12-git-send-email-arnd@arndb.de> <CAN8TOE8Y_2RMSrgMw7KwML88_1VA=QcJwuuMKEZpZCF5_dAQ=w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vMRLtMsFyQtH/vMwJ3uH0ENy9bLgFKxhtrUxVgWsMJp
 GXkAbkUfDo6oIdkIGVrU+tQac9Q03hxiWqpPOC7RHqp6OWCZZ4
 azbJZ+Af6Ce8z9u9VT487n/7fWc4/XNyDEmDCKrGuu+5MUnfGw
 6pPgmvuJMBNJbQxw9d0uxTOu6oXdEpfVV7Vv75dEKxtnzcI0i9
 HqLoUFS5Y+HNHRUca+bK8djfuOrZABQossmbQ2W6nfyjIMOV1k
 2TiBuu25Ebe07dV/Vxj1v8eTX/cbeLO9mcDWgb/g844/WdPH5p
 w6RhaB7dSlyhJBfz8ZeeJgB8o79p1c9eYRd9gaIMKdRiMj5Gb8
 5FOIXN5t/1RQ0sugWcB4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 May 2013 22:43:23 Brian Norris wrote:
> On Fri, May 31, 2013 at 3:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > This makes sure the conditionals for the declaration match the
> > definition, so we provide the alternative
> >
> >  #else
> >  #define IL_LEGACY_PM_OPS NULL
> >  #endif
> >
> > in the correct cases. As suggested by Borislav Petkov, this removes
> > the comments for the #else and #endif lines.
> 
> You seem to have missed the #endif line.

Yes, I screwed it up with a last minute change, sorry about this.
Will follow up with a new one.

	Arnd
