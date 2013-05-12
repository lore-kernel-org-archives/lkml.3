Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3ELPMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:12:48 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:57779 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab3ELPMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:12:46 -0400
MIME-Version: 1.0
In-Reply-To: <1368173847-5661-11-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
	<1368173847-5661-11-git-send-email-wsa@the-dreams.de>
Date: Sun, 12 May 2013 20:42:45 +0530
X-Google-Sender-Auth: GNHULL3gfnz_LLexQVsqQPW2edQ
Message-ID: <CAOh2x=nTCRb_uH5XA=N4JJwbZYSiXNZbi3cQeXDP4RxXuEFTGw@mail.gmail.com>
Subject: Re: [RFC 10/42] drivers/input/keyboard: don't check resource with devm_ioremap_resource
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 1:46 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/input/keyboard/spear-keyboard.c

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
