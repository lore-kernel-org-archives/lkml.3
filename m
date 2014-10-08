Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaJHSSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:18:06 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57661 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaJHSSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:18:04 -0400
Date: Wed, 8 Oct 2014 11:17:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: mpr121: Switch to using managed resources
Message-ID: <20141008181759.GD14423@dtor-ws>
References: <1412750911-16759-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412750911-16759-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 12:18:31PM +0530, Pramod Gurav wrote:
> This change switches to using devm_* managed resources APIs to
> request the resources in probe to simplify probe error path and
> module unloading and does away with remove function.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

I'll queue it for 3.19.

Thanks.

-- 
Dmitry
