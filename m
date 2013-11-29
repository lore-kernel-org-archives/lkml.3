Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab3K2PNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:13:13 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53653 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753168Ab3K2PNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:13:11 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Paul Drews <paul.drews@intel.com>, Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acpi: Add BayTrail SoC GPIO and LPSS ACPI IDs
Date: Fri, 29 Nov 2013 16:26:01 +0100
Message-ID: <1718119.5DfiJaEKmb@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CACRpkdZJTpUDO6ZxrUS+02docY8wDyz0eZP3AM3qA_WwoaKAbw@mail.gmail.com>
References: <1385417755-21776-1-git-send-email-paul.drews@intel.com> <1595199.2xkkMsZdTD@vostro.rjw.lan> <CACRpkdZJTpUDO6ZxrUS+02docY8wDyz0eZP3AM3qA_WwoaKAbw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 29, 2013 01:16:31 PM Linus Walleij wrote:
> On Thu, Nov 28, 2013 at 2:29 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Monday, November 25, 2013 02:15:55 PM Paul Drews wrote:
> >> This adds the new ACPI ID (INT33FC) for the BayTrail GPIO
> >> banks as seen on a BayTrail M System-On-Chip platform.  This
> >> ACPI ID is used by the BayTrail GPIO (pinctrl) driver to
> >> manage the Low Power Subsystem (LPSS).
> >>
> >> Signed-off-by: Paul Drews <paul.drews@intel.com>
> >
> > Linus, any objections to this?  If not, I'll take it for 3.14.
> 
> Go ahead,
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks!

