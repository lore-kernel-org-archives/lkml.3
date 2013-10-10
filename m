Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3JJXke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 19:40:34 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:39584 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3JJXkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 19:40:33 -0400
MIME-Version: 1.0
In-Reply-To: <1381444274.2367.44.camel@buesod1.americas.hpqcorp.net>
References: <20131009232642.GA12776@jtriplet-mobl1>
	<1381365455.2297.14.camel@buesod1.americas.hpqcorp.net>
	<CAD=FV=UD2TDBVrQeC4862WQwKG32723mG0D4e1qrzVHF9+koFg@mail.gmail.com>
	<1381440403.2367.32.camel@buesod1.americas.hpqcorp.net>
	<CAEgFheKsx+gKZa76333m4C-gPbEy2AFSVA3mCNR8HjaLFNb1Ww@mail.gmail.com>
	<1381444274.2367.44.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 10 Oct 2013 16:40:32 -0700
X-Google-Sender-Auth: bHQSq469JqgVxg1JVcTrp3S44E0
Message-ID: <CAD=FV=X_x9Ryn483H_gU9Wnq5bx7AAeMov0LY_nHACBL1X3ywQ@mail.gmail.com>
Subject: Re: Regression parsing GPT (EFI) partition tables
From: Doug Anderson <dianders@chromium.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Bill Richardson <wfrichar@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Sean Paul <seanpaul@chromium.org>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr,

On Thu, Oct 10, 2013 at 3:31 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> Then you should *really* use the force_gpt option, which is there to
> bypass any MBR checks, and you can avoid issues like this :)
>
> Anyway, this is still a regression and I believe we can go ahead and
> just warn the user about the case instead of not recognizing the disk.
>
> Bill/Doug, care to send a formal patch (with corresponding comments)?

OK, I've posted up at <https://patchwork.kernel.org/patch/3019531/>.
As I've said, I haven't spent the time to really understand every last
detail (I was just doing dumb git bisects), so if my explanation /
comments don't actually make sense then please correct me.

Thanks for your help in tracking this down!

-Doug
