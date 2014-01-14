Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaANQ3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:29:04 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52942 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751576AbaANQ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:29:00 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Takashi Iwai <tiwai@suse.de>, Len Brown <lenb@kernel.org>,
        Oliver Neukum <oneukum@suse.de>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ACPI: Blacklist Win8 OSI for some HP laptop 2013 models
Date: Tue, 14 Jan 2014 17:42:57 +0100
Message-ID: <6355285.UpbP9PuN7a@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140114161244.GD4307@srcf.ucam.org>
References: <1389611658-19424-1-git-send-email-tiwai@suse.de> <20140114161244.GD4307@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 14, 2014 04:12:44 PM Matthew Garrett wrote:
> On Mon, Jan 13, 2014 at 12:14:18PM +0100, Takashi Iwai wrote:
> > The BIOS on recent HP laptops behaves differently with Win8 OSI,
> > e.g. no backlight control and no rfkill are available.  List them in
> > the blacklist as a workaround.
> 
> What's the plan for fixing this properly?

What exactly do you mean by "fixing this properly"?

Rafael

