Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbaFYTFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:05:23 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:59313 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbaFYTFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:05:19 -0400
Date: Wed, 25 Jun 2014 15:05:11 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs/omfs/inode.c: replace count*size kzalloc by
 kcalloc
Message-ID: <20140625190511.GC399@localhost>
References: <1403720237-19131-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403720237-19131-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 08:17:17PM +0200, Fabian Frederick wrote:
> kcalloc manages count*sizeof overflow.
> 
> Cc: Bob Copeland <me@bobcopeland.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
