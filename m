Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3C1O6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:58:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35840 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab3C1O6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:58:15 -0400
Message-ID: <51545A86.10307@nvidia.com>
Date: Thu, 28 Mar 2013 08:58:14 -0600
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pinctrl: pinctrl_select_state: set the old_state
 back on error
References: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com> <1364471748-23192-3-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1364471748-23192-3-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 05:55 AM, Richard Genoud wrote:
> In unapply_new_state, the old state is re-applied, but p->state is not
> set back as it should.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

