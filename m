Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043Ab3CAMlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:41:45 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:36980 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAMlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:41:44 -0500
MIME-Version: 1.0
In-Reply-To: <1361109527.4302.1.camel@phoenix>
References: <1361109527.4302.1.camel@phoenix>
Date: Fri, 1 Mar 2013 13:41:43 +0100
Message-ID: <CACRpkdb2CroAaidOTYqQABW0DyYBprO4p27zw7MxnD=Gw7NWAA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: abx500: Add terminating entry for of_device_id table
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 2:58 PM, Axel Lin <axel.lin@ingics.com> wrote:

> The of_device_id table is supposed to be zero-terminated.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied!

Thanks,
Linus Walleij
