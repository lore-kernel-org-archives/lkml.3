Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaJHSeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:34:31 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:48790 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaJHSe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:34:29 -0400
Date: Wed, 8 Oct 2014 11:34:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: lpc32xx-keys: Switch to using managed resources
Message-ID: <20141008183424.GF14423@dtor-ws>
References: <1412750081-11205-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412750081-11205-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 12:04:41PM +0530, Pramod Gurav wrote:
> This change switches to using devm_* managed resources APIs to
> request the resources in probe to simplify probe error path and
> module unloading.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

I'll queue it for 3.19.

Thanks.

-- 
Dmitry
