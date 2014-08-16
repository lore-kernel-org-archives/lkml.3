Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaHPNLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 09:11:20 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:47640 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaHPNLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 09:11:18 -0400
Date: Sat, 16 Aug 2014 09:11:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: pata_samsung_cf: change ret type to signed
Message-ID: <20140816131115.GJ9305@htj.dyndns.org>
References: <1408194514-2001-1-git-send-email-arjun024@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408194514-2001-1-git-send-email-arjun024@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 06:38:34PM +0530, Arjun Sreedharan wrote:
> Change return type to signed int since it could be
> a negative errno.
> 
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>

Applied to libata/for-3.17-fixes.

Thanks.

-- 
tejun
