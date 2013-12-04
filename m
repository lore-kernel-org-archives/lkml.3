Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab3LDPZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:25:00 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:37282 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab3LDPY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:24:59 -0500
Date: Wed, 4 Dec 2013 10:24:55 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: [PATCHSET REPOST driver-core-next] kernfs: implement trusted.*
 xattr support
Message-ID: <20131204152455.GP3158@htj.dyndns.org>
References: <1385246402-1407-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385246402-1407-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, these two patches still apply as-is on top of the current
driver-core-next e756bc5670d0 ("kobject: fix kset sample error path").

Thanks.

-- 
tejun
