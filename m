Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3F0GVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:21:08 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:59908 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3F0GVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:21:06 -0400
Date: Thu, 27 Jun 2013 10:21:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] proc: Document that /proc/<pid>/task/<tid>/children
 really is per-thread
Message-ID: <20130627062101.GA22612@moon>
References: <20130626155728.GA2141@redhat.com>
 <5f9a6b3ab75b12f2c5ba61ea1f6f3b08e9952b55.1372280661.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f9a6b3ab75b12f2c5ba61ea1f6f3b08e9952b55.1372280661.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 02:05:01PM -0700, Andy Lutomirski wrote:
> I was surprised to discover that a process can have a parent that isn't
> a thread group leader.  (The usual ppid interfaces hide this, but the
> children list exposes it.)
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Looks good to me, thanks!

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

