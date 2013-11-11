Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3KKK7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:59:23 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45438 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3KKK7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:59:14 -0500
Date: Mon, 11 Nov 2013 16:30:19 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] uprobes: typeof(arch_uprobe->insn) cleanups
Message-ID: <20131111110019.GC21356@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20131109175350.GA17412@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109175350.GA17412@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111110-9332-0000-0000-0000021AEA06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 06:53:50PM +0100, Oleg Nesterov wrote:
> Hello.
> 
> Ananth, could you please explicitly ack or nack 2/2 ? It is
> really simple, but obviously I can't test it. And even if it
> is correct it should be merged only if you like it, this is
> the minor cleanup.

The changes look good and I have acked it.

Thanks Oleg!

Ananth

