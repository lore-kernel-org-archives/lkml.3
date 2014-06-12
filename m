Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaFLWyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:54:45 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:48830 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaFLWyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:54:44 -0400
MIME-Version: 1.0
In-Reply-To: <1402603992-12466-3-git-send-email-davidriley@chromium.org>
References: <1402603992-12466-1-git-send-email-davidriley@chromium.org>
	<1402603992-12466-3-git-send-email-davidriley@chromium.org>
Date: Thu, 12 Jun 2014 15:54:43 -0700
X-Google-Sender-Auth: TEvAk3R0HAjFpakj7seiEkBEIc0
Message-ID: <CAD=FV=UvJk_-cupv_oO6Q5_3u1L0px_TEvPLTeBnJ+heVJoWWQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] tools: add script to test udelay
From: Doug Anderson <dianders@chromium.org>
To: David Riley <davidriley@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Thu, Jun 12, 2014 at 1:13 PM, David Riley <davidriley@chromium.org> wrote:
> This script makes use of the udelay_test module to exercise udelay()
> and ensure that it is delaying long enough (as compared to ktime).
>
> Signed-off-by: David Riley <davidriley@chromium.org>
> ---
>  tools/time/udelay_test.sh | 66 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
