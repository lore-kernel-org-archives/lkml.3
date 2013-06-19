Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975Ab3FSRzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:55:32 -0400
Received: from longford.logfs.org ([213.229.74.203]:59608 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3FSRza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:55:30 -0400
Date: Wed, 19 Jun 2013 12:25:36 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jianguo Wu <wujianguo@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mmap: allow MAP_HUGETLB for hugetlbfs files
Message-ID: <20130619162536.GB7511@logfs.org>
References: <1371581225-27535-1-git-send-email-joern@logfs.org>
 <1371581225-27535-3-git-send-email-joern@logfs.org>
 <51C107E9.9050900@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51C107E9.9050900@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 June 2013 09:22:49 +0800, Jianguo Wu wrote:
> 
> We already have is_file_hugepages().

Indeed.  Much nicer now.  Thanks!

Jörn

--
The grand essentials of happiness are: something to do, something to
love, and something to hope for.
-- Allan K. Chalmers
