Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3H2GYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 02:24:44 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34409 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab3H2GYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:24:43 -0400
Date: Wed, 28 Aug 2013 23:24:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yanchuan Nian <ycnian@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmap: remove unnecessary assignment
In-Reply-To: <1377739424-21293-1-git-send-email-ycnian@gmail.com>
Message-ID: <alpine.DEB.2.02.1308282324280.16672@chino.kir.corp.google.com>
References: <1377739424-21293-1-git-send-email-ycnian@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Aug 2013, Yanchuan Nian wrote:

> From: Yanchuan Nian <ycnian@gmail.com>
> 
> pgoff is not used after the statement "pgoff = vma->vm_pgoff;",
> so the assignment is redundant.
> 
> Signed-off-by: Yanchuan Nian <ycnian@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
