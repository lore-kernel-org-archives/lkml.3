Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3AaPPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:15:36 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:32879 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab3AaPPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:15:33 -0500
MIME-Version: 1.0
In-Reply-To: <2048745.M7CAe2g1gj@vostro.rjw.lan>
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com>
	<18379918.sbmR7uiKVn@vostro.rjw.lan>
	<CAPPqfY2umN2Fab=APyt4=LM32x2av7nPruADX3dddTxdWG2Umg@mail.gmail.com>
	<2048745.M7CAe2g1gj@vostro.rjw.lan>
Date: Thu, 31 Jan 2013 16:15:31 +0100
Message-ID: <CAPPqfY2hrd54viFHKErWk_8uRLHP9WK54G0inJtyUFJKKunDOg@mail.gmail.com>
Subject: Re: Performance issue since 3.2.6
From: Olivier Doucet <webmaster@ajeux.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> I'm really not sure.  It looks like CONFIG_PM makes PM QoS affect cpuidle
> for you in a wrong way, so to speak.
>
> I suppose it's time to look into the code and see what makes the difference.

i'm not a kernel guru but I can help by testing any patch or
suggestions. Let me know what can I do to have this fixed.

Olivier
