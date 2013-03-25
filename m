Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3CYLkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:40:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab3CYLkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:40:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCH 3/3] serial: of_serial: Handle hw-flow-control property
Date: Mon, 25 Mar 2013 11:40:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ley Foon Tan <lftan@altera.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <1364211286-31611-1-git-send-email-heikki.krogerus@linux.intel.com> <1364211286-31611-4-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1364211286-31611-4-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251140.31866.arnd@arndb.de>
X-Provags-ID: V02:K0:O2/F3eTKDAaDhhTXxNSV9RstF7mmAYzOBzF2qQUi6rI
 V7DPOMkV8RxTbeOBD4WSMd3hdxtST5+34cTulJVVlikvYfEQBr
 TwxxsvOfAoP8bC7U7XclJnCMWU7kFKJ2gASSOfP6n9MjITRgC+
 2sjwqLB2D5fxHjDKoSc0NirAb/UPfa0jDLUxbTvByVOlWQoeBg
 /0RlnLDRM/kjkKeoZpedj7rX5yg2pK/j0EXHPRI0KziEhxgI0k
 0XPB6NCD013sNX9w7nUlLUZy6ThsATROfdPewvgug/S+9BUwnq
 B92hHO8lb96+yjX45gjVBQhVwmIR7/eEjLHs4/3kT1qRn/HUXi
 uc6xEdluNh4TH1KaLVAU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013, Heikki Krogerus wrote:
> This will add support for hardware flow control. It is
> limited to be used only with 8250 driver.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Does this imply that we can use hardware flow control only when this
flag is set in the device tree? I assumed that working flow control
would be the default. Is it not?

	Arnd
