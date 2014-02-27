Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbaB0BBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:01:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51488 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753369AbaB0BBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:01:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kieran Clancy <clancy.kieran@gmail.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>,
        Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Dennis Jansen <dennis.jansen@web.de>
Subject: Re: [PATCH] ACPI / EC: Clear stale EC events on Samsung systems
Date: Thu, 27 Feb 2014 02:16:41 +0100
Message-ID: <2283771.eQo0eImXtS@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGf84QK=YDN6MHTzEEc-1rbWHyGkBSbSdobaUwXV18d++EO+eg@mail.gmail.com>
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com> <CAGf84QK75jsXdnehwDNr8g+dCvdQKQ7+bgXmsbF_YFMKKYoGGw@mail.gmail.com> <CAGf84QK=YDN6MHTzEEc-1rbWHyGkBSbSdobaUwXV18d++EO+eg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 27, 2014 11:29:53 AM Kieran Clancy wrote:
> On Thu, Feb 27, 2014 at 11:15 AM, Kieran Clancy <clancy.kieran@gmail.com> wrote:
> >
> > I am the primary author, but I based the loop which calls
> > acpi_ec_query_unlocked() on a patch by Lan Tianyu. Juan provided the
> > initial idea (userspace workaround), and Dennis and Lan Tianyu
> > reviewed and suggested some changes to the code.
> 
> Oh, and I should add that Juan and Dennis both helped to test the
> patch extensively.

You can use Tested-by or Reported-and-tested-by for that.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
