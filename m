Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbaAHX6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:58:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaAHX6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:58:03 -0500
Date: Wed, 8 Jan 2014 15:58:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthias Oefelein <ma.oefelein@arcor.de>
Cc: devel@driverdev.osuosl.org, lisa@xenapiadmin.com,
        linux-kernel@i4.cs.fau.de, linux-kernel@vger.kernel.org,
        linux-kernel@rmueck.de
Subject: Re: [PATCH 5/6] beeceem: Fix newline issues at opening braces of
 conditional statements in InterfaceRx.c
Message-ID: <20140108235833.GA21409@kroah.com>
References: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
 <1389219310-8015-6-git-send-email-ma.oefelein@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389219310-8015-6-git-send-email-ma.oefelein@arcor.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 11:15:09PM +0100, Matthias Oefelein wrote:
> In InterfaceRx.c, opening braces of (if-)conditionals are mostly dislocated, meaning they are found behind an extra line break after the conditional statement.
> This patch moves the opening braces accordingly as specified by the official conding style guidelines.

Please properly line-wrap your changelog comments at 72 columns like git
asks you to when you type them in...

thanks,

greg k-h
