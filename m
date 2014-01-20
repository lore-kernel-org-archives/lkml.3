Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaATAPX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 19:15:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57864 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752193AbaATAPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 19:15:18 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [Resend][GIT PULL] Last minute ACPI fix for v3.13
Date: Mon, 20 Jan 2014 01:29:23 +0100
Message-ID: <3273592.IXfjZA4ZpZ@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1561890.zx3ITxE09Q@vostro.rjw.lan>
References: <1607643.bXgUGr2Zse@vostro.rjw.lan> <1561890.zx3ITxE09Q@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Saturday, January 18, 2014 02:31:00 PM Rafael J. Wysocki wrote:
> Hi Linus,
> 
> The original revert commit was missing the Fixes: and Reported-by: tags, so if
> you haven't pulled it yet, here it goes again with those tags added.
> 
> Please pull from the git repository at
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-3.13-fixup
> 
> to receive a last-minute ACPI fix for 3.13 as commit 
> 2b844ba79f4a114bd228ad6fee040ffd99a0963d
> 
>   Revert "ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs"
> 
> on top of commit 7e22e91102c6b9df7c4ae2168910e19d2bb14cd6
> 
>   Linux 3.13-rc8
> 
> This reverts a commit that causes the Alan Cox' ASUS T100TA to "crash and
> burn" during boot if the Baytrail pinctrl driver is compiled in.

Well, that will be a regression in 3.13 if we don't revert this commit, but
you apparently don't like the revert. :-)

Please let me know if you want me to add the revert to the 3.14-rc1 pull
request or just wait with it for the time being.

Rafael

