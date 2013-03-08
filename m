Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab3CHGRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:17:39 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:55851 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3CHGRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:17:37 -0500
Date: Fri, 8 Mar 2013 11:47:31 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: <oskar.andero@sonymobile.com>
Cc: <linux-kernel@vger.kernel.org>, <masami.hiramatsu.pt@hitachi.com>,
        <davem@davemloft.net>, <anil.s.keshavamurthy@intel.com>,
        <radovan.lekanovic@sonymobile.com>,
        Toby Collett <toby.collett@sonymobile.com>
Subject: Re: [PATCH] delay blacklist symbol lookup until we actually need it
Message-ID: <20130308061731.GC4029@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1362660318-30603-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362660318-30603-1-git-send-email-oskar.andero@sonymobile.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030806-4834-0000-0000-000004798F20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 01:45:18PM +0100, oskar.andero@sonymobile.com wrote:
> From: Toby Collett <toby.collett@sonymobile.com>
> 
> The symbol lookup can take a long time and kprobes is
> initialised very early in boot, so delay symbol lookup
> until the blacklist is first used.
> 
> Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> Signed-off-by: Toby Collett <toby.collett@sonymobile.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>

Sounds resonable.

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

