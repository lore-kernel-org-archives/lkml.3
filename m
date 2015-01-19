Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbbASOXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:23:51 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:46101 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbASOXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:23:49 -0500
Date: Mon, 19 Jan 2015 09:23:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH] libata: fixup oops in ata_eh_link_report()
Message-ID: <20150119142345.GF8140@htj.dyndns.org>
References: <1421668859-4593-1-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421668859-4593-1-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 01:00:59PM +0100, Hannes Reinecke wrote:
> We should only try to evaluate the cdb if this is an ATAPI
> device, for any other device the 'cdb' field and the cdb_len
> has no meaning.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

But, can you please refer to the commit which broke it and what the
result of the breakage was?  I suppose this should go through the same
tree that the offending commit went through, right?

Thanks.

-- 
tejun
