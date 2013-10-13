Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3JMRBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 13:01:13 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:42553 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3JMRBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 13:01:12 -0400
Date: Sun, 13 Oct 2013 13:01:06 -0400
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Matias Bjorling <m@bjorling.me>, koverstreet@google.com, tytso@mit.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu-refcount: Export symbols
Message-ID: <20131013170106.GB5253@mtj.dyndns.org>
References: <1381494492-1735-1-git-send-email-m@bjorling.me>
 <1381494492-1735-2-git-send-email-m@bjorling.me>
 <20131013110925.GD5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131013110925.GD5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 04:09:25AM -0700, Paul E. McKenney wrote:
> On Fri, Oct 11, 2013 at 02:28:12PM +0200, Matias Bjorling wrote:
> > Need to be exported for being used within modules.
> > 
> > Signed-off-by: Matias Bjorling <m@bjorling.me>
> 
> I will bite...  Why not EXPORT_SYMBOL_GPL()?

Seconded.  Please use EXPORT_SYMBOL_GPL.

Thanks.

-- 
tejun
