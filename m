Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab3FRN3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:29:41 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:62258 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3FRN3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:29:39 -0400
MIME-Version: 1.0
In-Reply-To: <1371558978-10870-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1371558978-10870-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Tue, 18 Jun 2013 22:29:38 +0900
Message-ID: <CANqRtoQUadXd+RGbW3S1S4vxvz+iQJVoAVXY-JL-2G-DJTT6WQ@mail.gmail.com>
Subject: Re: [PATCH v2] clocksource: sh_cmt: Use devm_* managed helpers
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 9:36 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> This simplifies the main error path by getting rid of it.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Looking good, thanks!

Acked-by: Magnus Damm <damm@opensource.se>
