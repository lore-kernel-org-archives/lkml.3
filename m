Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaHPMzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 08:55:52 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:54443 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaHPMzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 08:55:50 -0400
Date: Sat, 16 Aug 2014 08:55:46 -0400
From: Tejun Heo <tj@kernel.org>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: propagate return value of scc_wait_after_reset
Message-ID: <20140816125546.GF9305@htj.dyndns.org>
References: <CAJFMrCGvj4g+HFgS3sArZHJLH3fO1kAXsQwhTxgvOhbWywUtWw@mail.gmail.com>
 <1408193409-1867-1-git-send-email-arjun024@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408193409-1867-1-git-send-email-arjun024@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 06:20:09PM +0530, Arjun Sreedharan wrote:
> scc_bus_softreset not necessarily should return zero.
> Propagate the error code.
> 
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>

Applied to libata/for-3.17-fixes.

Thanks.

-- 
tejun
