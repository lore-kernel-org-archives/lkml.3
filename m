Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3A1KxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:53:12 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:50056 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3A1KxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:53:10 -0500
Date: Mon, 28 Jan 2013 11:53:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched: minimalist select_idle_sibling() bouncing cow
 syndrome fix
Message-ID: <20130128105304.GC20263@gmail.com>
References: <1359273021.5803.80.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359273021.5803.80.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <bitbucket@online.de> wrote:

> If the previous CPU is cache affine and idle, select it.

No objections in principle - but would be nice to have a 
changelog with numbers, % of improvement included and so?

Thanks,

	Ingo
