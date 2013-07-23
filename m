Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab3GWUok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:44:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3GWUoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:44:39 -0400
Date: Tue, 23 Jul 2013 13:44:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 44/48] staging/lustre/build: fix 'data race condition'
 issues
Message-ID: <20130723204438.GA21418@kroah.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
 <1374509230-3324-45-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374509230-3324-45-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 12:07:05AM +0800, Peng Tao wrote:
> From: Sebastien Buisson <sebastien.buisson@bull.net>
> 
> Fix 'data race condition' defects found by Coverity version
> 6.5.0:
> Data race condition (MISSING_LOCK)
> Accessing variable without holding lock. Elsewhere,
> this variable is accessed with lock held.

Again duplicate Subject: lines with the previous patch, so I've dropped
both.

thanks,

greg k-h
