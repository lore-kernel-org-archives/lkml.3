Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3ILQqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:46:35 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:36684 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3ILQqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:46:32 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1379003839-16068-1-git-send-email-galak@codeaurora.org>
References: <1379003839-16068-1-git-send-email-galak@codeaurora.org>
Date: Thu, 12 Sep 2013 09:46:31 -0700
Message-ID: <CAOesGMisWLwYKotGDFPW6PyHJs=_+fohTdC08SGjsv2FXaa7Fg@mail.gmail.com>
Subject: Re: [PATCH] ARM: msm: Move msm devicetrees under a Qualcomm dir
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 9:37 AM, Kumar Gala <galak@codeaurora.org> wrote:
> Use the Qualcomm vendor prefix (qcom) as the directory name for
> Qualcomm MSM devicetrees going forward.
>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

Let's not move just one platform like this. If we are to do this, we
should move everything, and that will be really painful and needs to
be done in a controlled manner, probably scripted and right before a
-rc1 or such.


-Olof
