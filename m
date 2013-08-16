Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab3HPLWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 07:22:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45260 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab3HPLWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 07:22:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Li Yang <leoli@freescale.com>
Cc: linux-pm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: System suspend states and device driver suspend() callback
Date: Fri, 16 Aug 2013 13:32:32 +0200
Message-ID: <17024788.0xFN8jEV59@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CADRPPNSD+uj_t5+qbNW29y7SuJkB_vMck-DGFJFV4A0AmPC6pQ@mail.gmail.com>
References: <CADRPPNSD+uj_t5+qbNW29y7SuJkB_vMck-DGFJFV4A0AmPC6pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 16, 2013 04:06:26 PM Li Yang wrote:
> Hi Guys,
> 
> Is there a standard way for the device drivers to know if the system
> is going to “standby” mode or “mem” mode when the suspend() callbacks
> are called?

No, there's none.

What do you need that for?

Rafael

