Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaEUKDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:03:30 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43073 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbaEUKDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:03:25 -0400
Date: Wed, 21 May 2014 14:03:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: shawn@churchofgit.com, akpm@linux-foundation.org, avagin@openvz.org,
        xemul@parallels.com, vdavydov@parallels.com
Subject: Re: [patch 0/3] timerfd -- implement missing parts to checkpoint and
 restore timerfd state, v3
Message-ID: <20140521100322.GB12819@moon>
References: <20140428212517.200264067@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428212517.200264067@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 01:25:17AM +0400, Cyrill Gorcunov wrote:
>
> Hello! This is (I hope) the final version. Most changes from v2 are sitting in
> documentation, where I tried to reflect that the time we're printing out is
> remaining until the timer expiration. Please take a look.

Thomas, ping?
