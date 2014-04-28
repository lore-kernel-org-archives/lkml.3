Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbaD1Uxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:53:38 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:49833 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaD1Uxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:53:36 -0400
Date: Tue, 29 Apr 2014 00:53:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: shawn@churchofgit.com, tglx@linutronix.de, akpm@linux-foundation.org,
        avagin@openvz.org, xemul@parallels.com, vdavydov@parallels.com
Subject: Re: [patch 0/3] timerfd -- implement missing parts to checkpoint and
 restore timerfd state, v2
Message-ID: <20140428205334.GD16176@moon>
References: <20140407174701.734703531@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407174701.734703531@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 09:47:01PM +0400, Cyrill Gorcunov wrote:
> Hi, here is an updated series, changes mostly in show_fdinfo code which now
> produces a way more information (and documentation update). Please take a look
> once time permit. Thanks!

Hi, any new comments on this series?
