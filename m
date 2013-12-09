Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761378Ab3LIRGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:06:51 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52617 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761354Ab3LIRGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:06:37 -0500
Message-ID: <52A5F899.1070706@wwwdotorg.org>
Date: Mon, 09 Dec 2013 10:06:33 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        thierry.reding@gmail.com
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] clocksource: tegra: remove deprecated IRQF_DISABLED
References: <1381639360-6920-1-git-send-email-michael.opdenacker@free-electrons.com> <1386581745-4559-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1386581745-4559-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 02:35 AM, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.

I assume that the maintainers for drivers/clocksource/ will apply this.
If not, let me know, and I can take it through the Tegra tree.

