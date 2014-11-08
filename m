Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaKHBOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 20:14:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63296 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753296AbaKHBOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 20:14:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kevin Hilman <khilman@kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / Runtime: Rework RPM get callback routines
Date: Sat, 08 Nov 2014 02:35:33 +0100
Message-ID: <128680201.KjCx8uRyDk@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7hd29aahc5.fsf@deeprootsystems.com>
References: <1413543482-12748-1-git-send-email-a.hajda@samsung.com> <7hd29aahc5.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 29, 2014 10:58:18 AM Kevin Hilman wrote:
> Andrzej Hajda <a.hajda@samsung.com> writes:
> 
> > PM uses three separate functions to fetch RPM callbacks.
> > These functions uses quite complicated macro in their body.
> > The patch replaces these routines with one small macro and
> > one helper function.
> >
> > Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> 
> Acked-by: Kevin Hilman <khilman@linaro.org>

Patch queued up for 3.19-rc1, thanks everyone!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
