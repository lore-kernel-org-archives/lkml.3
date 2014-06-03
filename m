Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935096AbaFCQnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:43:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54051 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935025AbaFCQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:43:06 -0400
Message-ID: <538DFB16.3020407@wwwdotorg.org>
Date: Tue, 03 Jun 2014 10:43:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: FanWu <fwu@marvell.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        Chao Xie <cxie4@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Ning Jiang <njiang1@marvell.com>, Xiaofan Tian <tianxf@marvell.com>,
        Fangsuo Wu <fswu@marvell.com>
Subject: Re: [PATCH v4] pinctrl: to avoid duplicated calling enable_pinmux_setting
 for a pin
References: <1401781077-31150-1-git-send-email-fwu@marvell.com> <538D7DEB.7020000@marvell.com>
In-Reply-To: <538D7DEB.7020000@marvell.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 01:48 AM, FanWu wrote:
> On 06/03/2014 03:37 PM, fwu@marvell.com wrote:
>> From: Fan Wu <fwu@marvell.com>
>>
>> What the patch did:
>> 1.To call pinmux_disable_setting ahead of pinmux_enable_setting in
>> each time of
>>    calling pinctrl_select_state
>> 2.Remove the HW disable operation in in pinmux_disable_setting function.
>> 3.Remove the disable ops in struct pinmux_ops
...
> For the "signed-off" part, I added the "Stephen" because I change the
> code inline comments according to the suggestion from Stephen.

The point is that you can NEVER write S-o-b for someone else, only for
yourself. Given the small contribution from me in this patch, the
following would be better ways to credit me:

1) Not bother since it's a tiny comment

2) In patch description:
(includes comment fixes from Stephen Warren)

3) In patch description final paragraph, before your S-o-b:
Based-on-work-by: Stephen Warren <swarren@nvidia.com>

(although (3) isn't really appropriate here, since my contribution was
tiny compared to the overall patch, and came after the original patch
rather than being inspiration for it)
