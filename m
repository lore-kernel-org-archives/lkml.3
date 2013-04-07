Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969Ab3DGPlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 11:41:45 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:64831 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab3DGPlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 11:41:44 -0400
Message-ID: <516193BC.3000503@gmail.com>
Date: Sun, 07 Apr 2013 11:41:48 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 3/3] mm: when handling percpu_pagelist_fraction, use on_each_cpu()
 to set percpu pageset fields.
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com> <1365194030-28939-4-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1365194030-28939-4-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/5/13 4:33 PM), Cody P Schafer wrote:
> In free_hot_cold_page(), we rely on pcp->batch remaining stable.
> Updating it without being on the cpu owning the percpu pageset
> potentially destroys this stability.
> 
> Change for_each_cpu() to on_each_cpu() to fix.
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


