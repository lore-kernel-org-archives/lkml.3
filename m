Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3KSWp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:45:58 -0500
Received: from kanga.kvack.org ([205.233.56.17]:50726 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab3KSWpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:45:54 -0500
Date: Tue, 19 Nov 2013 17:45:54 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: viro@zeniv.linux.org.uk, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] aio: nullify aio->ring_pages after freeing it
Message-ID: <20131119224554.GG14098@kvack.org>
References: <1384900383-22009-1-git-send-email-sasha.levin@oracle.com> <1384900383-22009-2-git-send-email-sasha.levin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384900383-22009-2-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 05:33:03PM -0500, Sasha Levin wrote:
> After freeing ring_pages we leave it as is causing a dangling pointer. This
> has already caused an issue so to help catching any issues in the future
> NULL it out.

Applied as well,  I'll send this out after running some tests on the 
resulting tree tonight.

		-ben
-- 
"Thought is the essence of where you are now."
