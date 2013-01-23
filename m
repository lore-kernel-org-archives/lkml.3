Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3AWEOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:14:32 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33312 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752392Ab3AWEOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:14:30 -0500
Message-ID: <1358914468.2107.26.camel@joe-AO722>
Subject: Re: [PATCH] lib: vsprintf: Add %pa format specifier for phys_addr_t
 types
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>, mingo@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Tue, 22 Jan 2013 20:14:28 -0800
In-Reply-To: <CAMuHMdWedqgvrSCfpmDFdM=ww-6+8v39sz+92CQaYHO4x5jNNQ@mail.gmail.com>
References: <1358833677-15611-1-git-send-email-stepanm@codeaurora.org>
	 <CAMuHMdWedqgvrSCfpmDFdM=ww-6+8v39sz+92CQaYHO4x5jNNQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 23:26 +0100, Geert Uytterhoeven wrote:
> On Tue, Jan 22, 2013 at 6:47 AM, Stepan Moskovchenko
> <stepanm@codeaurora.org> wrote:
> > Add the %pa format specifier for printing a phys_addr_t
> > type, since the physical address size on some platforms
> > can vary based on build options, regardless of the native
> > integer type.
> 
> I'm not so sure it's a good idea to start using %p for integer types.

It would also require that some automatic variables
that could otherwise be used in registers be put on
the stack.


