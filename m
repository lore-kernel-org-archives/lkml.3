Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3EUNKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:10:41 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:59426 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754220Ab3EUNKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:10:39 -0400
Message-ID: <519B7249.2070207@hurleysoftware.com>
Date: Tue, 21 May 2013 09:10:33 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>, gregkh@linuxfoundation.org
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY:vt: convert remain take_over_console's users to do_take_over_console
References: <20130521051511.GA11435@udknight>
In-Reply-To: <20130521051511.GA11435@udknight>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 01:15 AM, Wang YanQing wrote:
> Impact:
> 1:convert all remain take_over_console to do_take_over_console
> 2:update take_over_console to do_take_over_console in comment
>
> Commit dc9641895abb ("vt: delete unneeded functions
> register_con_driver|take_over_console") delete take_over_console,
> but forget to convert remain take_over_console's users to new API
> do_take_over_console, this patch fix it.
>
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>   Sorry for my mistake, I believe I do the full
>   kernel source find|grep, but the reality is I
>   forget  take_over_console.

I would rather revert dc9641895abb which purported to delete
_unneeded_ functions than have this. Obviously the functions
were needed.

Regards,
Peter Hurley
