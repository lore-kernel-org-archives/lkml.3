Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab3JWIRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:17:24 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:64115 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3JWIRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:17:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuJ=Qvj2pT57T88eURrUOFURRFSXrFA+pL4xiA9c5sh9ig@mail.gmail.com>
References: <1382030498-23465-1-git-send-email-acourbot@nvidia.com>
	<CACRpkdYx07Kfs6zOQmTg2cTSmEmsGgP=7wMCSG_30NW=dfYRPQ@mail.gmail.com>
	<CAAVeFu+rj6AtKgfig6ZrYUzW9HZTg5qLyw4aGozyD31P_pEKAQ@mail.gmail.com>
	<CACRpkdbpRkiANA32ZMEhm-XTB_FKCfmKQuGSmsD_0rLi96kPtQ@mail.gmail.com>
	<CAAVeFuJ=Qvj2pT57T88eURrUOFURRFSXrFA+pL4xiA9c5sh9ig@mail.gmail.com>
Date: Wed, 23 Oct 2013 10:17:20 +0200
Message-ID: <CACRpkdZnj1n-Uegu0TwNiTHXXBti0ukZ8hzmm22+Jg6OFnEi5Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] New descriptor-based GPIO interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 12:18 AM, Alexandre Courbot <gnurou@gmail.com> wrote:

> Autobuild was unfortunately not too happy with one of the patches,
> sorry about that. I have sent a small series that addresses the issues
> it highlighted. Not sure if you are ok with squashing the first two
> into bae48da2, but IMHO that would be the preferred way.

I applied them as-is. I don't think it's going to be a major
issue.

Yours,
Linus Walleij
