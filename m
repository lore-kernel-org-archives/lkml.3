Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966990Ab3HIATq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:19:46 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:42051 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966940Ab3HIATp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:19:45 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <CAD=FV=U3aT1KKtSwAFhYURJJerp70ij8h647=xyV51et4jYipg@mail.gmail.com>
References: <CAD=FV=U3aT1KKtSwAFhYURJJerp70ij8h647=xyV51et4jYipg@mail.gmail.com>
Date: Thu, 8 Aug 2013 17:19:44 -0700
Message-ID: <CAOesGMjaF2K0CnuWBj7xdXGAQk-XRetBstaQdd9EZzBYrmDjeA@mail.gmail.com>
Subject: Re: dw_mmc: Does anyone use multiple slots?
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@google.com>
Cc: James Hogan <james.hogan@imgtec.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sonny Rao <sonnyrao@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 5:16 PM, Doug Anderson <dianders@google.com> wrote:

> I guess my overall question is: if there are no actual implementations
> of multislot, shouldn't we kill it and simplify the code a whole lot?
> If someone out there has a real multislot device they can step back in
> and do it more correctly?
>
> Of course we need to find someone to actually go through and do the
> killing of multislot, but finding that person might be easier if there
> was some agreement that it was good to do.

There clearly seems to be no in-tree users of multislot. If someone
new comes in, we have the code in the history and can revert the
removal (or at least use it as reference for re-introduction).

I vote for removing it. It adds really annoying complexity for
something that nobody uses.


-Olof
