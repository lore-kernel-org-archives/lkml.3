Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3DWOtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:49:41 -0400
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:47738 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab3DWOtk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:49:40 -0400
Date: Tue, 23 Apr 2013 14:46:35 +0000 (UTC)
From: Thorsten Glaser <t.glaser@tarent.de>
X-X-Sender: tg@herc.mirbsd.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update AMD powerflags comments
In-Reply-To: <201304231422.r3NEMhHB003395@herc.mirbsd.org>
Message-ID: <Pine.BSM.4.64L.1304231444140.7138@herc.mirbsd.org>
References: <201304231422.r3NEMhHB003395@herc.mirbsd.org>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dixi quod…

>+	"100mhzsteps", /* 100 MHz multiplier control */
>+	"hwpstate", /* hardware P-state control */
> 	"",	/* tsc invariant mapped to constant_tsc */

Are patches to correct the indentation style desired?
I’d just put in two tabs (one after the longer texts)
myself…

(In case someone wonders, we were comparing server boxen
at work today, and nobody seemed to know what stc was; a
suggestion was “stable clock” since the box with*out* it
had clock stability issues with full-virtualised guests,
the other didn’t… turns out that was not it.)

bye,
//mirabilos
-- 
tarent solutions GmbH
Rochusstraße 2-4, D-53123 Bonn • http://www.tarent.de/
Tel: +49 228 54881-393 • Fax: +49 228 54881-314
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Boris Esser, Sebastian Mancke
