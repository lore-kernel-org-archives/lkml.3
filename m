Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3IOVEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 17:04:35 -0400
Received: from one.firstfloor.org ([193.170.194.197]:34860 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3IOVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 17:04:34 -0400
Date: Sun, 15 Sep 2013 23:04:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joe Perches <joe@perches.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] checkpatch: add rules to check init attribute and
 const defects
Message-ID: <20130915210433.GV18242@two.firstfloor.org>
References: <1375740651-7716-1-git-send-email-andi@firstfloor.org>
 <1379276783.3641.3.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379276783.3641.3.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 01:26:23PM -0700, Joe Perches wrote:
> People get this regularly wrong and it breaks the LTO builds,
> as it causes a section attribute conflict.
> 
> Original-patch-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks looks good.
-Andi
