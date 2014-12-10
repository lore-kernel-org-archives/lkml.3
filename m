Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbaLJU5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:57:51 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48793 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758197AbaLJU5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:57:50 -0500
Date: Wed, 10 Dec 2014 20:57:46 +0000
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Long Li <longli@microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Message-ID: <20141210205746.GB1209@sucs.org>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418200705-488-1-git-send-email-longli@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 12:38:25AM -0800, Long Li wrote:
> MSFT targets currently claim SPC-2 compliance while they implement
> post SPC-2 features. With this patch we can correctly handle
> WRITE_SAME_16 issues.
> 
> This patch fixes an issue where the flag is setup too late in drive
> initialization process.

Li, is this a fix for the issue I keep whinging about over in
https://lkml.org/lkml/2014/10/21/23 ?

If is the same issue you may want to CC Martin on this...

-- 
Sitsofe | http://sucs.org/~sits/
