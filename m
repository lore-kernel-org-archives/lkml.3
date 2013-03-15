Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab3COUKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:10:00 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52510 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3COUJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:09:59 -0400
Date: Fri, 15 Mar 2013 13:09:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Voytik <dvv.kernel@gmail.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: lowmemorykiller: well-marked debug
 print
Message-ID: <20130315200956.GA14440@kroah.com>
References: <1363377642-15414-1-git-send-email-dvv.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363377642-15414-1-git-send-email-dvv.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 12:00:42AM +0400, Dmitry Voytik wrote:
> Add "lmk:" prefix to the debug print so it's easier to analyse LMK's
> debug output:
> dmesg | grep lmk

Ick, no, please use the proper interface for this (i.e. pr_fmt).

greg k-h
