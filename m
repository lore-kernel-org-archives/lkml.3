Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaIKSRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 14:17:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbaIKSRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 14:17:52 -0400
Date: Thu, 11 Sep 2014 14:17:41 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RESEND][PATCH] userns: use marco instead of magic number for
 max userns level
Message-ID: <20140911181741.GU22290@redhat.com>
References: <1410429091-7234-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410429091-7234-1-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 05:51:31PM +0800, Chen Hanxiao wrote:
> Use marco instead of magic number
> for max user namespace level.

patch is ok, but you might want to do s/marco/macro/

-- 
Aristeu

