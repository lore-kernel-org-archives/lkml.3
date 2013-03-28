Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3C1O5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:57:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44661 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3C1O5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:57:41 -0400
Message-ID: <51545A64.5090609@nvidia.com>
Date: Thu, 28 Mar 2013 08:57:40 -0600
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] pinctrl: use dev_info instead of pr_info in pinctrl_select_state_locked
References: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 05:55 AM, Richard Genoud wrote:
> And remove superfluous brackets.

(Seems like those unrelated changes might have benefited from being two
separate patches, but not a big deal, especially if this actually gets
squashed)

Reviewed-by: Stephen Warren <swarren@nvidia.com>

