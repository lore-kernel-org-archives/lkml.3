Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab3IKHpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 03:45:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab3IKHpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 03:45:15 -0400
Date: Wed, 11 Sep 2013 09:46:00 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [197/251] iwl4965: reset firmware after rfkill off
Message-ID: <20130911074559.GA2368@redhat.com>
References: <20130911042707.738353451@goodmis.org>
 <20130911042924.950506810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911042924.950506810@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 12:30:24AM -0400, Steven Rostedt wrote:
> 3.6.11.9-rc1 stable review patch.
> If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> [ Upstream commit 788f7a56fce1bcb2067b62b851a086fca48a0056 ]

This require follow up - upstream commit:

commit b2fcc0aee58a3435566dd6d8501a0b355552f28b
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Wed Aug 21 10:18:19 2013 +0200

    iwl4965: fix rfkill set state regression

which seems to be missed on the set.

Stanislaw
