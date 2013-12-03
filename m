Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3LCWzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:55:24 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:37985 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3LCWzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:55:20 -0500
Date: Tue, 3 Dec 2013 17:55:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 06/23] mm/char: remove unnecessary inclusion of
 bootmem.h
Message-ID: <20131203225513.GV8277@htj.dyndns.org>
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
 <1386037658-3161-7-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386037658-3161-7-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 09:27:21PM -0500, Santosh Shilimkar wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Clean-up to remove depedency with bootmem headers.
> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Please merge 4-6 into a single patch.

Thanks.

-- 
tejun
