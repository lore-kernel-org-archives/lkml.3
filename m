Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3C2QK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:10:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52242 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab3C2QKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:10:25 -0400
Message-ID: <5155BCEF.4020907@wwwdotorg.org>
Date: Fri, 29 Mar 2013 10:10:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pinctrl: simplify the re-enable old state code in
 pinctrl_select_state
References: <1364547807-22370-1-git-send-email-richard.genoud@gmail.com> <1364547807-22370-2-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1364547807-22370-2-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 03:03 AM, Richard Genoud wrote:
> Instead of just enabling the settings that were disabled in the 1st
> loop, it's simpler to recall pinctrl_select_state with the old state.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
