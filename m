Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab3HJSvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 14:51:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3HJSvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 14:51:03 -0400
Date: Sat, 10 Aug 2013 11:52:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH] isa: Change driver to use dev_pm_ops infrastructure
Message-ID: <20130810185226.GA13293@kroah.com>
References: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 09:20:46AM -0600, Shuah Khan wrote:
> Change isa bus to register dev_pm_ops via bus_type.pm. Add freeze ops for
> PM_EVENT_FREEZE handling.

why?
