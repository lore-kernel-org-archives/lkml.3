Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3GSW6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 18:58:16 -0400
Received: from longford.logfs.org ([213.229.74.203]:59834 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3GSW6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 18:58:15 -0400
Date: Fri, 19 Jul 2013 17:26:37 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] [SCSI] sg: push file descriptor list locking
 down to per-device locking
Message-ID: <20130719212637.GD29404@logfs.org>
References: <20130715203730.GA21804@logfs.org>
 <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
 <1374075246-22923-5-git-send-email-vaughan.cao@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374075246-22923-5-git-send-email-vaughan.cao@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 July 2013 23:34:06 +0800, Vaughan Cao wrote:
> Date: Wed, 17 Jul 2013 23:34:06 +0800
> From: Vaughan Cao <vaughan.cao@oracle.com>
> To: joern@logfs.org
> Cc: dgilbert@interlog.com, JBottomley@parallels.com,
> 	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
> 	vaughan.cao@oracle.com
> Subject: [PATCH v4 4/4] [SCSI] sg: push file descriptor list locking down
>  to per-device locking
> X-Mailer: git-send-email 1.7.11.7
> 
> Push file descriptor list locking down to per-device locking. Let sg_index_lock
> only protect device lookup.
> sdp->detached is also set and checked with this lock held.
> 
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>

Reviewed-by: Joern Engel <joern@logfs.org>

Jörn

--
What one programmer can do in one month, two programmers can do in two months.
-- Fred Brooks
