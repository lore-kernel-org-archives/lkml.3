Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaJYTdg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:33:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62879 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaJYTdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:33:35 -0400
Message-ID: <544B7F20.40301@gmail.com>
Date: Sat, 25 Oct 2014 12:44:48 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linus.walleij@linaro.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] pinctrl: add helpers for group based drivers
References: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.10.2014 10:04, Antoine Tenart wrote:
> Linus, Sebastian,
>
> As discussed earlier this year[1], this series introduce helpers for group based
> pinctrl drivers:
> - of_pinctrl_utils_read_function(): reads the function name of a
>    specified node, and gets the number of groups it should be
>    applied to.
> - of_pinctrl_for_each_function_group(): navigates through the groups of
>    a specified node, reading at each iteration the name of the current
>    group.
>
> A generic function to parse nodes for group based drivers is also added, and
> then used in the Berlin pinctrl driver:
> - pinconf_generic_function_groups_dt_node_to_map()
>
> [1] https://lkml.org/lkml/2014/5/17/38

Antoine,

thanks for looking into this!

 From Berlin POV,

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> Antoine Tenart (4):
>    Documentation: bindings: pinctrl: document the generic groups property
>    pinctrl: add helpers for group based drivers
>    pinctrl: add a generic way to map node to map for group based drivers
>    pinctrl: berlin: use the generic node to map function
>
>   .../bindings/pinctrl/pinctrl-bindings.txt          |  1 +
>   drivers/pinctrl/berlin/Kconfig                     |  1 +
>   drivers/pinctrl/berlin/berlin.c                    | 53 +---------------------
>   drivers/pinctrl/pinconf-generic.c                  | 36 +++++++++++++++
>   drivers/pinctrl/pinctrl-utils.c                    | 26 +++++++++++
>   drivers/pinctrl/pinctrl-utils.h                    |  9 ++++
>   include/linux/pinctrl/pinconf-generic.h            |  3 ++
>   7 files changed, 78 insertions(+), 51 deletions(-)
>

