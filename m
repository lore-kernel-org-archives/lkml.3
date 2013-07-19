Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab3GSWvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 18:51:09 -0400
Received: from longford.logfs.org ([213.229.74.203]:59826 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3GSWvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 18:51:07 -0400
Date: Fri, 19 Jul 2013 17:19:29 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] [SCSI] sg: no need sg_open_exclusive_lock
Message-ID: <20130719211929.GB29404@logfs.org>
References: <20130715203730.GA21804@logfs.org>
 <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
 <1374075246-22923-3-git-send-email-vaughan.cao@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374075246-22923-3-git-send-email-vaughan.cao@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 July 2013 23:34:04 +0800, Vaughan Cao wrote:
> Date: Wed, 17 Jul 2013 23:34:04 +0800
> From: Vaughan Cao <vaughan.cao@oracle.com>
> To: joern@logfs.org
> Cc: dgilbert@interlog.com, JBottomley@parallels.com,
> 	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
> 	vaughan.cao@oracle.com
> Subject: [PATCH v4 2/4] [SCSI] sg: no need sg_open_exclusive_lock
> X-Mailer: git-send-email 1.7.11.7
> 
> Open exclusive check is protected by o_sem, no need sg_open_exclusive_lock.
> @exclude is used to record which type of rwsem we are holding.
> 
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
Reviewed-by: Joern Engel <joern@logfs.org>

Jörn

--
"Error protection by error detection and correction."
-- from a university class
