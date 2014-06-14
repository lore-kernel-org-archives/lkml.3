Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaFNBKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 21:10:11 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:35219 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaFNBKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 21:10:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XZENSV1ZnpEURd9ZbBwKUnUdzqoO8ufG846nVEEpA92Q@mail.gmail.com>
References: <1402684097-5731-1-git-send-email-mcgrof@do-not-panic.com>
 <1402695712.27369.10.camel@buesod1.americas.hpqcorp.net> <CAB=NE6XZENSV1ZnpEURd9ZbBwKUnUdzqoO8ufG846nVEEpA92Q@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 13 Jun 2014 18:09:48 -0700
X-Google-Sender-Auth: 1xA5SuGIEsirP5GH2DAY5nNXgrM
Message-ID: <CAB=NE6Uk8VhP18ANmOHykWC_iYH2AdkcPaT=kQTwEpeEdPo4Kw@mail.gmail.com>
Subject: Re: [PATCH v3] printk: allow increasing the ring buffer depending on
 the number of CPUs
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: hpa@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Chris Metcalf <cmetcalf@tilera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing an issue with a small kernel ring buffer on a small system
with this for some reason though. Please hold off on merging this for
now.

 Luis
