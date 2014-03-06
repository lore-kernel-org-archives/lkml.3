Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbaCFAhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:37:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64757 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756871AbaCFAhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:37:42 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kieran Clancy <clancy.kieran@gmail.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Guang <lig.fnst@cn.fujitsu.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Dennis Jansen <dennis.jansen@web.de>
Subject: Re: [PATCH v2] ACPI / EC: Clear stale EC events on Samsung systems
Date: Thu, 06 Mar 2014 01:52:51 +0100
Message-ID: <1885040.WKp5oRmh5C@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGf84Q+7=abgk78WuhNWdy+3kgXma1fHj6OPk9ytQ4kFzcoFJA@mail.gmail.com>
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com> <53176D59.3030602@canonical.com> <CAGf84Q+7=abgk78WuhNWdy+3kgXma1fHj6OPk9ytQ4kFzcoFJA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 06, 2014 11:04:14 AM Kieran Clancy wrote:
> On Thu, Mar 6, 2014 at 5:00 AM, Joseph Salisbury
> <joseph.salisbury@canonical.com> wrote:
> > I notice there was no cc to stable.  Were you also planning on
> > submitting this for inclusion in the upstream stable kernels?
> 
> I don't really know the process for stable kernels
> (Documentation/SubmittingPatches mentions nothing), but of course I'd
> like it included if possible.
> 
> Rafael, is it a separate process to get this in the stable tree or
> will it naturally happen after being merged into the mainline?

I need to add a proper "CC stable" tag to your patch for this to happen.

Which -stable kernels should it go to?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

