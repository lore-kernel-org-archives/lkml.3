Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693AbaD2OoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:44:21 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38620 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaD2OoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:44:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140429131332.GA7049@kroah.com>
References: <1398774909-13649-1-git-send-email-grant.likely@linaro.org> <20140429131332.GA7049@kroah.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Tue, 29 Apr 2014 15:43:53 +0100
X-Google-Sender-Auth: 6dYpLFjvqRO3ErPvEz0r-k8wlPw
Message-ID: <CACxGe6ttEonR5iESqbYeBgVx_kU48tTD3t_QYD1-8Gf2gi3yew@mail.gmail.com>
Subject: Re: [PATCH v4] drivercore: deferral race condition fix
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@kernel.org>, Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 2:13 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Apr 29, 2014 at 01:35:09PM +0100, Grant Likely wrote:
>> When the kernel is built with CONFIG_PREEMPT it is possible to reach a state
>> when all modules loaded but some driver still stuck in the deferred list
>> and there is a need for external event to kick the deferred queue to probe
>> these drivers.
[...]
>> Hi Greg,
>>
>> This change needs to go into 3.15. I've got this patch in the
>> devicetree/merge branch of my tree and can ask Linus to pull it directly
>> if you would like.
>
> Sure, that would be fine:
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks Greg

I'll give it a few days in linux-next and then ask Linus to pull.

g.
