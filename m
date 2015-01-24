Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbbAXBWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:22:36 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:55349 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbbAXBWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:22:31 -0500
MIME-Version: 1.0
In-Reply-To: <1422060853-1067-2-git-send-email-bjorn.andersson@sonymobile.com>
References: <1422060853-1067-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1422060853-1067-2-git-send-email-bjorn.andersson@sonymobile.com>
Date: Fri, 23 Jan 2015 17:22:29 -0800
Message-ID: <CAJAp7OgpF2-b5zWJ-_z_yPejPO8LFZpT7dD7h0Wo3X5wV5xBjw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] leds: add Qualcomm PM8941 WLED driver
From: Bjorn Andersson <bjorn@kryo.se>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-leds@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 4:54 PM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
> From: Courtney Cavin <courtney.cavin@sonymobile.com>
>
> This adds support for the WLED ('White' LED) block on Qualcomm's
> PM8941 PMICs.
>
> Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---

Sorry, I missed the change log.

Changed since v1:
* Replace enum blob with defines
* Merged wled_context and wled structs
* Some style updates

Regards,
Bjorn
