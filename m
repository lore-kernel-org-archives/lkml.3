Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaFRRn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:43:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42704 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaFRRn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:43:58 -0400
Date: Wed, 18 Jun 2014 18:43:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs/sysv/namei.c: code clean-up
Message-ID: <20140618174355.GN18016@ZenIV.linux.org.uk>
References: <1403112862-7158-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403112862-7158-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 07:34:22PM +0200, Fabian Frederick wrote:
> Fixing checkpatch errors:
> 
> "foo * bar" should be "foo *bar"
> code indent should use tabs where possible
> trailing whitespace

Err...  How about saner subject?  s/code clean-up/whitespace noise removal/,
or something like that...
