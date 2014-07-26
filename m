Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbaGZGJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 02:09:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaGZGJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 02:09:44 -0400
Date: Fri, 25 Jul 2014 23:09:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arjun AK <arjunak234@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        sparmaintainer@unisys.com, benjamin.romer@unisys.com,
        david.kershner@unisys.com
Subject: Re: [PATCH] Staging: unisys: Fix code style
Message-ID: <20140726060917.GA29568@kroah.com>
References: <2159111.NPHfj36gbu@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2159111.NPHfj36gbu@thinkpad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 03:37:41PM +0530, Arjun AK wrote:
> >From 8e7748dd81cf63c62dbef8f102e97da1d4d5d90a Mon Sep 17 00:00:00 2001
> From: Arjun AK <arjunak234@gmail.com>
> Date: Fri, 25 Jul 2014 15:09:11 +0530
> Subject: [PATCH] Staging: unisys: Fix code style

Why is all of this here in this message?

> 
> Fixes code style in multiple files

Please break this up into one logical change per patch, and be specific
as to what you change.

> 
> Signed-off-by: Arjun AK <arjunak234@gmail.com>

I need a "full" name here, sorry.

greg k-h
