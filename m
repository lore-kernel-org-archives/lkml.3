Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935935AbaH0VBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:01:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45645 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935499AbaH0VBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:01:14 -0400
Date: Wed, 27 Aug 2014 22:01:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: rtg.canonical@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH 3.17-rc2] fs: namespace: suppress 'may be used
 uninitialized' warnings
Message-ID: <20140827210112.GE18016@ZenIV.linux.org.uk>
References: <1409169065-61597-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409169065-61597-1-git-send-email-tim.gardner@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 01:51:05PM -0600, rtg.canonical@gmail.com wrote:
> From: Tim Gardner <tim.gardner@canonical.com>
> 
> The gcc version 4.9.1 compiler complains Even though it isn't possible for
> these variables to not get initialized before they are used.

Blanket NAK, at that - any patches adding that 'uninitialized_...'
garbage in fs/*.c will be rejected and, should they slip in in some
other way - reverted.  Consider that as a local policy.
