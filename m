Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbaD2VrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:47:21 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:40218 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaD2VrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:47:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140429211128.GF29634@quack.suse.cz>
References: <CAOMZO5Bb3P20S15Hi8fKO1r8-JOQa3j8GekNBiABVb9XXN0hZw@mail.gmail.com>
	<20140429211128.GF29634@quack.suse.cz>
Date: Tue, 29 Apr 2014 18:47:19 -0300
Message-ID: <CAOMZO5B8xedf_skGekzKP8kG=4BQj8eom6xvEypqnuQbf9wBUA@mail.gmail.com>
Subject: Re: Warning from kernel/printk/printk.c in linux-next
From: Fabio Estevam <festevam@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 6:11 PM, Jan Kara <jack@suse.cz> wrote:
>   Hello,
>
> On Tue 29-04-14 13:33:17, Fabio Estevam wrote:
>> I am running linux-next 20140429 on a mx6 board (ARM 32-bit) and after commit
>> 5dc90cb49691755faa ("printk: enable interrupts before calling
>> console_trylock_for_printk()") I get the following warning:
>   Thanks for report. Attached patch should fix the problem I hope.

Thanks, I don't get the warning with your patch applied:

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
