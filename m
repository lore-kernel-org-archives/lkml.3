Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbaJ3Neg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:34:36 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60325 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759802AbaJ3Ned (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:34:33 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.140.208]
In-Reply-To: <20141030003806.GU28611@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412037291-16880-6-git-send-email-bjorn.andersson@sonymobile.com>
 <CADMYwHxLtAZZMUGX3jo0URAezqGuho5XB=hQJp8k+acBiENrhg@mail.gmail.com> <20141030003806.GU28611@sonymobile.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 30 Oct 2014 15:34:12 +0200
Message-ID: <CAK=WgbbP8UQAbFauE80PnF5bj3FTAkB2KfF0kFE8Pt23jQrDhA@mail.gmail.com>
Subject: Re: [RFC 5/7] soc: qcom: Add Shared Memory Driver
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Thu, Oct 30, 2014 at 2:38 AM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
> My concern is that merging SMD into rpmsg will still give us two different
> solutions, except that they will be deeply tangled.

I agree.

It's very clear that SMD and rpmsg are different. But fundamentally,
they do exactly the same: new messages are placed in a ring buffer and
then an interrupt is triggered.

If Qualcomm wanted to adopt rpmsg I'm confident there would have been
no technical barriers to do so.

But given that SMD is not going anywhere, I personally hope that you
could at least avoid having two different implementations of it merged
upstream.

Good luck,
Ohad.
