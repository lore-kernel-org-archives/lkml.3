Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaEPVBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:01:11 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:53654 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaEPVBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:01:09 -0400
Date: Fri, 16 May 2014 17:01:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] devres: Add devm_get_free_pages API
Message-ID: <20140516210106.GN5379@htj.dyndns.org>
References: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
 <1400228799-8832-2-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400228799-8832-2-git-send-email-eli.billauer@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 11:26:35AM +0300, Eli Billauer wrote:
> devm_get_free_pages() and devm_free_pages() are the managed counterparts
> for __get_free_pages() and free_pages().
> 
> Signed-off-by: Eli Billauer <eli.billauer@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
