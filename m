Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3JHUC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:02:29 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:52520 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3JHUC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:02:27 -0400
Date: Wed, 9 Oct 2013 00:02:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] Soft dirty tracking fixes
Message-ID: <20131008200224.GB19040@moon>
References: <20131008090019.527108154@gmail.com>
 <20131008125013.85dcccf418260d43b6cb120a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008125013.85dcccf418260d43b6cb120a@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 12:50:13PM -0700, Andrew Morton wrote:
> 
> Do you consider the problems which patches 1 and 2 address to be
> sufficiently serious to justify backporting into -stable?

Good question! Yeah, since dirty bit traking is in 3.11 already,
it would be great to merge these two patches into -stable.
Should I resend them with stable team CC'ed?
