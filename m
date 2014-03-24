Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaCXPmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 11:42:00 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:43800 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbaCXPl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 11:41:59 -0400
Date: Mon, 24 Mar 2014 16:41:41 +0100
From: Eric =?UTF-8?B?QsOpbmFyZA==?= <eric@eukrea.com>
To: CHAUMETTE Hubert <hchaumette@adeneo-embedded.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        shawn guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] ARM: i.MX6: update KSZ9031 phy fixup
Message-ID: <20140324164141.51b85f8c@e6520eb>
In-Reply-To: <1762157698.5689069.1395675049240.JavaMail.zimbra@adeneo-embedded.com>
References: <1395421687-12934-1-git-send-email-hchaumette@adeneo-embedded.com>
	<20140321222320.14370739@e6520eb>
	<1762157698.5689069.1395675049240.JavaMail.zimbra@adeneo-embedded.com>
Organization: =?UTF-8?B?RXVrcsOpYQ==?= Electromatique
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hubert,

Le Mon, 24 Mar 2014 16:30:49 +0100 (CET),
CHAUMETTE Hubert <hchaumette@adeneo-embedded.com> a écrit :
> > From: "Eric Bénard" <eric@eukrea.com>
> > that's board specific (the needed delay depends on the routing delay on
> > the PCB), so this should not go in a generic file.
> > 
> > Eric
> > 
> 
> I admit it may need to be in a separate function, but this file already contains
> board-specific fixups (for imx6q sabrelite, Data Modul eDM-QMX6).
> 
true but that's not a reason to add more ;-)

> Anyway, do you have any suggestion for the location I should put it ?
> 
no idea at the moment, I simply used your patch to bring this issue on
the ML as we recently needed to patch the default values for testing
mainline kernel on a custom boards.

Eric
