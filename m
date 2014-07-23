Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbaGWQC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:02:28 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:51175 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435AbaGWQC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:02:26 -0400
Message-ID: <1406131339.2488.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] m68k/q40: Revert "m68k/q40: Fix q40_irq_startup() to
 return -ENXIO on failures"
From: Davidlohr Bueso <davidlohr@hp.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Sasha Levin <sasha.levin@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-m68k@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Date: Wed, 23 Jul 2014 09:02:19 -0700
In-Reply-To: <CAPDOMVj7mP3uBGKP-pGgc7mrZXyun4rc7xsAi+=faC-hhKUmWQ@mail.gmail.com>
References: <1406119899-22659-1-git-send-email-sasha.levin@oracle.com>
	 <53CFC170.9090505@roeck-us.net>
	 <CAPDOMVj7mP3uBGKP-pGgc7mrZXyun4rc7xsAi+=faC-hhKUmWQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 11:39 -0400, Nick Krause wrote:
> I guess this is another bad patch :(.

This is an example of you wasting peoples time with thoughtless patches.
Please stop. You've been asked a million times.

