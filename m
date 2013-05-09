Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3EIU5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:57:31 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:38863 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3EIU53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:57:29 -0400
Date: Thu, 9 May 2013 13:57:01 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: neilb@suse.de, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] bcache: Fix incompatible pointer type warning
Message-ID: <20130509205701.GC15040@moria.home.lan>
References: <1368131966-17512-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368131966-17512-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 10:39:26PM +0200, Emil Goode wrote:
> The function pointer release in struct block_device_operations
> should point to functions declared as void.

Looks like .release just changed to returning void in the merge window -
thanks, applied
