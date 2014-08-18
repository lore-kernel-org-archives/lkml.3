Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaHRTId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 15:08:33 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:57440 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaHRTIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 15:08:30 -0400
MIME-Version: 1.0
X-Originating-IP: [63.138.66.171]
In-Reply-To: <1408387131-32152-1-git-send-email-agross@codeaurora.org>
References: <1408387131-32152-1-git-send-email-agross@codeaurora.org>
Date: Mon, 18 Aug 2014 12:08:29 -0700
Message-ID: <CAOesGMi1RsP=L2BG5kUfnnjD5B7kW_SDDDiqRrEuY7RvS8HyyA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add entry for SOC Qualcomm drivers
From: Olof Johansson <olof@lixom.net>
To: Andy Gross <agross@codeaurora.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 11:38 AM, Andy Gross <agross@codeaurora.org> wrote:
> This patch adds a MAINTAINERS entry for the SOC Qualcomm drivers.
>
> Signed-off-by: Andy Gross <agross@codeaurora.org>

Hm. I always figured the drivers/soc/<platform> hierarchy would be
maintained by the subplatform maintainers, not by other developers.
Main thought behind that was that we might want to cause a bit of
bottle neck here, to make sure that at least one person has the full
picture of what's going on across the platform as a whole.

That doesn't mean it _has_ to be that way though. And I'll leave it up
to Kumar to decide for his platform. I.e. this would need an ack from
him.


-Olof
