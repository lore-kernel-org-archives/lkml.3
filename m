Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaEVV7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:59:41 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:47568 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaEVV7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:59:40 -0400
MIME-Version: 1.0
In-Reply-To: <5377351A.6000609@gmail.com>
References: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
	<1399267649-20218-2-git-send-email-antoine.tenart@free-electrons.com>
	<5377351A.6000609@gmail.com>
Date: Thu, 22 May 2014 23:59:39 +0200
Message-ID: <CACRpkdbbyfPqFP=-+gO8TmOXSgovjkR_e=N57Xmj-N8jptOzVQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] pinctrl: berlin: add the core pinctrl driver for
 Marvell Berlin SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 12:08 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> thinking of your request to make "function"/"groups" standard
> properties, I guess you also had some corresponding helpers in
> mind.

Yeah :-)

> Looking at the map and free functions here, I can see no Berlin
> specific code at all. One option would be to make those functions
> a standard callback for .dt_node_to_map and .dt_free_map, i.e.
> pinctrl_utils_function_group_dt_node_to_map.
>
> IMHO, the more flexible option would be to rather have
>
> of_pinctrl_utils_read_function(node, &function_name, &ngroups)
> and
> of_pinctrl_for_each_function_group(node, group_name)
> swallowing the property names and reuse it like below.
>
> The simple option would be to just remove the marvell, prefix
> now and have a closer look at other pinctrl drivers to see what
> will be required, of course.
>
> Do you have any preference?

I would prefer a two-stage rocket, one removing the Marvell prefix
and another bringing the helpers into pinctrl-utils.

Do I hear a patch coming? :-)

Yours,
Linus Walleij
