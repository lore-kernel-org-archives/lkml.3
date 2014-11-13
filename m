Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbaKMJEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:04:34 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33529 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaKMJE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:04:26 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.100.67]
In-Reply-To: <5463B9F7.8040105@ti.com>
References: <1410553499-55951-1-git-send-email-s-anna@ti.com>
 <1410553499-55951-6-git-send-email-s-anna@ti.com> <CAK=WgbZE7_WrsNz5E+MDX7j2tAGEjv91zeCgqhB=Jsiu0+d8vw@mail.gmail.com>
 <5463B9F7.8040105@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 13 Nov 2014 11:04:05 +0200
Message-ID: <CAK=WgbadSrhJ6hnE2Wf=k74bmyq04vfWAOU-r7iL=A++Y+myMg@mail.gmail.com>
Subject: Re: [PATCHv6 5/5] hwspinlock/omap: add support for dt nodes
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Wed, Nov 12, 2014 at 9:50 PM, Suman Anna <s-anna@ti.com> wrote:
> None of the OMAPs have multiple IP instances, and as such the base-id is
> an optional property. I have made this change to make sure we atleast
> attempt to use the value if mentioned in DT and not hard-coding the
> value to begin with (going by the optional property semantics). If and
> when multiple instances get added and a secondary node doesn't add the
> property, the node will not be registered with the core due to an
> overlap failure.

Ok, that sounds good.

Thanks,
Ohad.
