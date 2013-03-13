Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3CMDwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 23:52:03 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:53624 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab3CMDwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 23:52:00 -0400
Date: Tue, 12 Mar 2013 20:52:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Suman Anna <s-anna@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: Re: [PATCHv3 01/14] mailbox: rename pl320-ipc specific mailbox.h
Message-ID: <20130313035252.GA1515@kroah.com>
References: <1363145030-14373-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363145030-14373-1-git-send-email-s-anna@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 10:23:50PM -0500, Suman Anna wrote:
> The patch 30058677 "ARM / highbank: add support for pl320 IPC"
> added a pl320 IPC specific header file as a generic mailbox.h.
> This file has been renamed appropriately to allow the
> introduction of the generic mailbox API framework.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/cpufreq/highbank-cpufreq.c |  2 +-
>  drivers/mailbox/pl320-ipc.c        |  2 +-
>  include/linux/mailbox.h            | 17 -----------------
>  include/linux/pl320-ipc.h          | 17 +++++++++++++++++
>  4 files changed, 19 insertions(+), 19 deletions(-)
>  delete mode 100644 include/linux/mailbox.h
>  create mode 100644 include/linux/pl320-ipc.h

Why are you sending these To: me?  I'm not the mailbox maintainer, and
have never handled them before that I can remember.  Who is the
maintainer?

greg k-h
