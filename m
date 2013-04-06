Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab3DFGBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 02:01:20 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37476 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3DFGBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 02:01:18 -0400
Date: Fri, 5 Apr 2013 23:01:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@android.com, arve@android.com,
        john.stultz@linaro.org, Dave.Butcher@arm.com
Subject: Re: [PATCH 4/8] staging: android: binder: fix printk() format
 specifier
Message-ID: <20130406060116.GB11127@kroah.com>
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
 <1365078758-28674-5-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365078758-28674-5-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 01:32:34PM +0100, Serban Constantinescu wrote:
> Fix format specifiers warnings introduced by the previous patch which
> changes some structures in binder.h.

Please merge this with the patch that caused the problems.

