Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaFXV7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:59:41 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57460 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaFXV7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:59:39 -0400
Date: Tue, 24 Jun 2014 14:59:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Maksym Planeta <mcsim.planeta@gmail.com>
cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Knauth <thomas.knauth@gmx.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
In-Reply-To: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
Message-ID: <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Maksym Planeta wrote:

> To clean the page cache one can use /proc/sys/vm/drop_caches. But this
> drops the whole page cache. In contrast to that sdrop_caches enables
> ability to drop the page cache selectively by path string.
> 
> Suggested-by: Thomas Knauth <thomas.knauth@gmx.de>
> Signed-off-by: Maksym Planeta <mcsim.planeta@gmail.com>

Could you include some information in the commit message about why this is 
useful?  Specifically, why you want to drop pagecache only from a specific 
path.

The name of the sysctl is also quite non-descriptive.
