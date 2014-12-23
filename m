Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbaLWVAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 16:00:30 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:59079 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaLWVA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 16:00:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Baruch Siach <baruch@tkos.co.il>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] ARM: digicolor: add low level debug support
Date: Tue, 23 Dec 2014 22:00:17 +0100
Message-ID: <2866303.axqKJidzX4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <d161e426125c28c9698fa5fecad4e5278abc0895.1419318109.git.baruch@tkos.co.il>
References: <cover.1419318109.git.baruch@tkos.co.il> <d161e426125c28c9698fa5fecad4e5278abc0895.1419318109.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:kSNpsyUyGuPMowzw75IkNA3fQBArYsWg7FCClz8ZCk4R7ufppUA
 9LPEJCtY6Vb7xxD/DYAlGoMTioMJePU7QSYLNDCtMqP6iqKSkALPx6H58TWBkSLBCZNNH3x
 DAQCvkSM7Y3fSojRDT2lffg4aO7sHdkVzFdGwogIMfbjU7PKkBtB1QnxhoV4WZGpN/BnSyK
 POszOLkS3AGOof0crAkgA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 December 2014 09:58:39 Baruch Siach wrote:
> @@ -14,5 +14,6 @@ static const char *digicolor_dt_compat[] __initconst = {
>  };
>  
>  DT_MACHINE_START(DIGICOLOR, "Conexant Digicolor (Flattened Device Tree)")
> +       .map_io         = debug_ll_io_init,
>         .dt_compat      = digicolor_dt_compat,
>  MACHINE_END

This change is not needed, the debug_ll_io_init function is used by default
if no other map_io callback is specified.

	Arnd
