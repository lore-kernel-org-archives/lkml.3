Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702Ab3BKXeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:34:11 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:54942 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760203Ab3BKXeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:34:09 -0500
Message-ID: <51197FEE.9070606@kernel.org>
Date: Mon, 11 Feb 2013 18:34:06 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: linux-next: manual merge of the acpi tree with the pm tree
References: <20130211125856.64b216a03dd18218c4627635@canb.auug.org.au>
In-Reply-To: <20130211125856.64b216a03dd18218c4627635@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2013 08:58 PM, Stephen Rothwell wrote:
> Hi Len,
> 
> Today's linux-next merge of the acpi tree got a conflict in
> drivers/acpi/processor_idle.c between commit 4f8429166818 ("ACPICA:
> Cleanup PM_TIMER_FREQUENCY definition") from the pm tree and commit
> 41cdb0efc42e ("ACPI / idle: remove unused definition") from the acpi tree.
> 
> I fixed it up (The latter removed the lines modified by the former, so I
> did that) and can carry the fix as necessary (no action is required).
> 

Thank you Stephen,
Go ahead and keep these two merge fix-ups.

We'll either merge the rjw and the lenb trees before
sending to Linus, or let him repeat your merge
fix-ups as he likes to do.

BTW. Rafael's "pm" tree now carries the ACPI patch stream,
so it is probably a mis-representation to call my tree the "acpi" tree.
My tree is primarily focused on the "idle" part of pm these days.

thanks,
Len Brown, Intel Open Source Technology Center

