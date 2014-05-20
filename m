Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaETL0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:26:22 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63040 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaETL0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:26:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAGo_u6o+Vysq0LkdFTrP82WOpS1TT-=MD+zgP+Q_L=3RV8x5hA@mail.gmail.com>
References: <1400230809-11401-1-git-send-email-chander.kashyap@linaro.org>
	<537A0247.1030503@ti.com>
	<CAKohpoknoFuz8qnDpunA7oxr5E_18=+EQsFEy0P39fcU=4Ps9w@mail.gmail.com>
	<CAGo_u6o+Vysq0LkdFTrP82WOpS1TT-=MD+zgP+Q_L=3RV8x5hA@mail.gmail.com>
Date: Tue, 20 May 2014 16:56:20 +0530
Message-ID: <CAKohponAx=Hi_Ywgg4hXxrpmmaqy5=pYnb3nSBNUP3KtADTEeA@mail.gmail.com>
Subject: Re: [PATCH v3] PM / OPP: discard duplicate OPPs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Chander Kashyap <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2014 16:54, Nishanth Menon <nm@ti.com> wrote:
> That is upto the caller. returning 0 for an operation we were supposed
> to do, but due to error checks, did not do, implies we need to provide
> appropriate error back to caller. caller may choose to act upon the
> error and do something OR not - depending on what the caller is (for
> example, caller may choose to abort the full sequence as it does not
> trust the entries anymore, OR maybe trying to add optional OPP - whose
> failure is ignored) - it is NOT upto the this code to implement that
> policy.

But we aren't talking about failure here. Its not failure. The operation
we are trying to do is already done and nothing should break if the
OPP was already there or its added now. Its all the same.
