Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaIZL1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:27:13 -0400
Received: from mx2.parallels.com ([199.115.105.18]:54114 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaIZL1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:27:10 -0400
Date: Fri, 26 Sep 2014 15:27:04 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, Greg Thelen <gthelen@google.com>,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@sr71.net>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] kernel: res_counter: remove the unused API
Message-ID: <20140926112704.GG29445@esperanza>
References: <1411573390-9601-1-git-send-email-hannes@cmpxchg.org>
 <1411573390-9601-4-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411573390-9601-4-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:43:10AM -0400, Johannes Weiner wrote:
> All memory accounting and limiting has been switched over to the
> lockless page counters.  Bye, res_counter!
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Vladimir Davydov <vdavydov@parallels.com>
