Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaAGPoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:44:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbaAGPoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:44:09 -0500
Date: Tue, 7 Jan 2014 10:44:04 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] dm snapshot: Calling destroy_work_on_stack() to pair
 with INIT_WORK_ONSTACK()
Message-ID: <20140107154404.GA7983@redhat.com>
References: <1389084605.3650.66.camel@cliu38-desktop-build>
 <1389084978.3650.73.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389084978.3650.73.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07 2014 at  3:56am -0500,
Chuansheng Liu <chuansheng.liu@intel.com> wrote:

> 
> In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
> call destroy_work_on_stack() which frees the debug object to pair
> with INIT_WORK_ONSTACK().
> 
> Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>

Applied to linux-dm.git's 'for-next' branch.

Thanks,
Mike
