Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaJGQcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:32:25 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60158 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaJGQcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:32:23 -0400
Date: Tue, 7 Oct 2014 09:32:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: lm8323: Switch to using managed resources
Message-ID: <20141007163218.GD16469@dtor-ws>
References: <1412674689-20132-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412674689-20132-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pramod,
On Tue, Oct 07, 2014 at 03:08:09PM +0530, Pramod Gurav wrote:
> This change switches to using devm_* APIs to allocate  resources.
> This helps to simplify failure path in probe function as well as
> remove function.
> 

I prefer not mixing the automatic and manual resource management in a
single driver, so if you can't convert everything to devm_* API I prefer
to leave the code as is.

Thanks.

-- 
Dmitry
