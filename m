Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987Ab3BMS0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:26:18 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52819 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759463Ab3BMS0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:26:16 -0500
Date: Wed, 13 Feb 2013 10:26:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mikhail Gruzdev <michail.gruzdev@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] printk: add pr_devel_once and pr_devel_ratelimited
Message-ID: <20130213182613.GD7661@kroah.com>
References: <1360765583-27802-1-git-send-email-michail.gruzdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360765583-27802-1-git-send-email-michail.gruzdev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 06:26:23PM +0400, Mikhail Gruzdev wrote:
> Standardize pr_devel logging macros family by adding pr_devel_once and
> pr_devel_ratelimited.
> 
> Signed-off-by: Mikhail Gruzdev <michail.gruzdev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
