Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaLYU3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 15:29:04 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:58261 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaLYU27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 15:28:59 -0500
Date: Thu, 25 Dec 2014 15:28:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:ata: Fix spelling typos in libata-scsi.c and the
 header file,ata.h
Message-ID: <20141225202856.GE22951@htj.dyndns.org>
References: <1419219397-14627-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419219397-14627-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 10:36:37PM -0500, Nicholas Krause wrote:
> Changes the spelling typos of removeable to removable where ata_id_removeable is defined in
> ata.h and called in libata-scsi.c respectively.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Well, this isn't exactly wrong but why not?  Applied to
libata/for-3.20 with the description updated.

Thanks.

-- 
tejun
