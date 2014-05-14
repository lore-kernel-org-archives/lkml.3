Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaENWtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:49:13 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:43651 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaENWtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:49:11 -0400
MIME-Version: 1.0
In-Reply-To: <1399421543-7751-3-git-send-email-davidriley@chromium.org>
References: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
	<1399421543-7751-3-git-send-email-davidriley@chromium.org>
Date: Wed, 14 May 2014 15:49:10 -0700
X-Google-Sender-Auth: g8byFZMJmN2lLKMbxF_sXRbnRIU
Message-ID: <CAD=FV=XMiDqyfc2PWzp7e-itBXRgBmR0vwidNxLQOohY+Wf+Cg@mail.gmail.com>
Subject: Re: [PATCH 2/2] tools: add script to test udelay
From: Doug Anderson <dianders@chromium.org>
To: David Riley <davidriley@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Tue, May 6, 2014 at 5:12 PM, David Riley <davidriley@chromium.org> wrote:
> This script makes use of the udelay_test module to exercise udelay()
> and ensure that it is delaying long enough (as compared to ktime).
>
> Signed-off-by: David Riley <davidriley@chromium.org>
> ---
>  tools/time/udelay_test.sh |   66 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
>  create mode 100644 tools/time/udelay_test.sh

Potentially this could be created with execute permissions?

Other than that, this looks good to me.

Reviewed-by: Doug Anderson <dianders@chromium.org>
