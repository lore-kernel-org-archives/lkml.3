Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab3AKTMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 14:12:53 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63550 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab3AKTMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 14:12:52 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 2/2][V2] cpuidle - optimize the select function for the 'menu' governor
From: Julius Werner <jwerner@google.com>
In-Reply-To: <50CDF2A2.3090405@gmail.com>
Date: Fri, 11 Jan 2013 11:12:49 -0800
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, rjw@sisk.pl,
        jwerner@chromium.org, linux-pm@vger.kernel.org,
        deepthi@linux.vnet.ibm.com, g.trinabh@gmail.com,
        linaro-dev@lists.linaro.org, len.brown@intel.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        snanda@chromium.org
Content-Transfer-Encoding: 7BIT
Message-Id: <AF9BE237-8E69-4D09-BB78-EE54058EDE56@google.com>
References: <1355493455-30665-1-git-send-email-daniel.lezcano@linaro.org> <1355493455-30665-3-git-send-email-daniel.lezcano@linaro.org> <50CDF2A2.3090405@gmail.com>
To: Francesco Lavra <francescolavra.fl@gmail.com>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*Ping!*

Happy New Year everyone. Is there any update on this? I think Francesco already pointed out how to solve the last remaining issue with this, so I hope we can now resubmit these patches and finally get them merged. Daniel?