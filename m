Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaJHSZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:25:44 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56648 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaJHSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:25:42 -0400
Date: Wed, 8 Oct 2014 11:25:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: pxa27x_keypad: Switch to using managed resources
Message-ID: <20141008182538.GE14423@dtor-ws>
References: <1412765411-6480-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412765411-6480-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 04:20:11PM +0530, Pramod Gurav wrote:
> This change switches to using devm_* APIs to allocate  resources.
> This helps to simplify failure path in probe function and module
> unloading and does away with remove function.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

I'll queue it for 3.19.

Thanks.

-- 
Dmitry
