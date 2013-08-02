Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3HBQrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:47:31 -0400
Received: from kawka.in.waw.pl ([178.63.212.103]:36860 "EHLO kawka.in.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab3HBQra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:47:30 -0400
X-Greylist: delayed 1117 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2013 12:47:29 EDT
Date: Fri, 2 Aug 2013 18:28:50 +0200
From: Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        systemd-devel@lists.freedesktop.org
Subject: Re: Slow firmware timeouts again (Re: [3.11 regression?] iwlwifi
 firmware takes two minutes to load)
Message-ID: <20130802162850.GL32474@in.waw.pl>
References: <CALCETrU+C+sO8tJ0X5G4RDVLV=kHQQHurOnEQCoqbAouh60dng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU+C+sO8tJ0X5G4RDVLV=kHQQHurOnEQCoqbAouh60dng@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 09:04:44AM -0700, Andy Lutomirski wrote:
> CONFIG_FW_LOADER_USER_HELPER=y
Do you need this? Unsetting this should help.

"""This option enables / disables the invocation of user-helper
(e.g. udev) for loading firmware files as a fallback after the
direct file loading in kernel fails. The user-mode helper is
no longer required unless you have a special firmware file that
resides in a non-standard path."""

Zbyszek
-- 
they are not broken. they are refucktored
                           -- alxchk
