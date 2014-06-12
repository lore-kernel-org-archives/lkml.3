Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaFLUGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:06:09 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:38230 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaFLUGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:06:07 -0400
MIME-Version: 1.0
In-Reply-To: <1402594402-30374-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1402594402-30374-1-git-send-email-bjorn.andersson@sonymobile.com>
Date: Thu, 12 Jun 2014 13:06:06 -0700
Message-ID: <CAJAp7OgSKBqu1Xi0WFWCj=yqp+1PJcBtb9d5WCB8Lgo_EuspJg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Qualcomm Resource Power Manager driver
From: Bjorn Andersson <bjorn@kryo.se>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 10:33 AM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
> Changes since v1:
>   - Moved rpm driver to drivers/soc
[...]
>  include/linux/mfd/qcom_rpm.h                       |  12 +

Missed the last one in the move...

s/mfd/soc/

Will wait a little before sending out v3, to allow time for other comments.

// Bjorn
