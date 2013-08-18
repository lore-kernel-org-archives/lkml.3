Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab3HRWGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 18:06:48 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:41103 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab3HRWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 18:06:47 -0400
Message-ID: <52114574.3060701@cogentembedded.com>
Date: Mon, 19 Aug 2013 02:06:44 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Maarten ter Huurne <maarten@treewalker.org>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: musb: Avoid null pointer dereference in debug logging
References: <1376842864-27839-1-git-send-email-maarten@treewalker.org>
In-Reply-To: <1376842864-27839-1-git-send-email-maarten@treewalker.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 18-08-2013 20:21, Maarten ter Huurne wrote:

> Since commit 511f3c53 usb_gadget_remove_driver will pass NULL for the

    Please also specify that commit's summary line in parens.

> driver argument.

> Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
> ---
>   drivers/usb/musb/musb_gadget.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

WBR, Sergei


