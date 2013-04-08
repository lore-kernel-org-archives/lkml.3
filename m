Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3DHEIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:08:01 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39147 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3DHEIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:08:00 -0400
Date: Sun, 7 Apr 2013 21:07:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: MT - handle semi-mt devices in core
Message-ID: <20130408040756.GA6479@core.coreip.homeip.net>
References: <1365363692-986-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365363692-986-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 07, 2013 at 09:41:32PM +0200, Henrik Rydberg wrote:
> Most semi-mt drivers use the slots in a manual way, but really only
> need to treat the finger count manually. With this patch, a semi-mt
> driver may use the input-mt core for everything else.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied, thank you Henrik.

-- 
Dmitry
