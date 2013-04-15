Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab3DOQbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:31:06 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:56583 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab3DOQbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:31:01 -0400
Date: Mon, 15 Apr 2013 09:30:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        akpm@linux-foundation.org, wency@cn.fujitsu.com, mgorman@suse.de,
        tj@kernel.org, liwanp@linux.vnet.ibm.com, linux-mm@kvack.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: Remove unused parameter of
 pages_correctly_reserved()
Message-ID: <20130415163040.GA2750@kroah.com>
References: <1366019207-27818-1-git-send-email-tangchen@cn.fujitsu.com>
 <1366019207-27818-2-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366019207-27818-2-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 05:46:45PM +0800, Tang Chen wrote:
> nr_pages is not used in pages_correctly_reserved().
> So remove it.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Reviewed-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
