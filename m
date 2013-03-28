Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3C1O6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:58:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53635 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab3C1O6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:58:05 -0400
Message-ID: <51545A7C.3070403@nvidia.com>
Date: Thu, 28 Mar 2013 08:58:04 -0600
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] pinctrl: remove superfluous optimization in pinctrl_select_state_locked
References: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com> <1364471748-23192-2-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1364471748-23192-2-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 05:55 AM, Richard Genoud wrote:
> As Stephen Warren suggested, checking first if the setting->node entry
> is the first in the list or not is superfluous, as it is checked again
> in the list_for_each_entry bellow.
> So, remove it, the code will be simpler and lighter !

Reviewed-by: Stephen Warren <swarren@nvidia.com>

