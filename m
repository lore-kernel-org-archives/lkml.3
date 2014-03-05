Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbaCEWeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:34:05 -0500
Received: from mail-yk0-f173.google.com ([209.85.160.173]:43127 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbaCEWcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:32:16 -0500
MIME-Version: 1.0
In-Reply-To: <1393223377-5744-2-git-send-email-tuukka.tikkanen@linaro.org>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
	<1393223377-5744-2-git-send-email-tuukka.tikkanen@linaro.org>
Date: Wed, 5 Mar 2014 17:26:07 -0500
X-Google-Sender-Auth: hNNQI5ROwcXOShaqwSNKiDOEKUM
Message-ID: <CAJvTdK=o98vwR7V0fRz3big57R0FcUrZcohzLCz0OrnhgG-auw@mail.gmail.com>
Subject: Re: [PATCH 1/7] Cpuidle: rename expected_us to next_timer_us in menu governor
From: Len Brown <lenb@kernel.org>
To: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch renames expected_us to next_timer_us in order to better
> reflect the contained information.
>
> Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>

Acked-by: Len Brown <len.brown@intel.com>
