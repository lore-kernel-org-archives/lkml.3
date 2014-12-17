Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaLQTQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:16:41 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53771 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaLQTQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:16:40 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: Stop BUGing the system
References: <1418831495-26958-1-git-send-email-nm@ti.com>
Date: Wed, 17 Dec 2014 11:16:36 -0800
In-Reply-To: <1418831495-26958-1-git-send-email-nm@ti.com> (Nishanth Menon's
	message of "Wed, 17 Dec 2014 09:51:35 -0600")
Message-ID: <7hoar29je3.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> CPUFRreq subsystem is not a system catastrophic failure point.
> Failures in these cases DONOT need complete system shutdown with BUG.
> just refuse to let cpufreq function should be good enough.
>
> Signed-off-by: Nishanth Menon <nm@ti.com>

Acked-by: Kevin Hilman <khilman@linaro.org>
