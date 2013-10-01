Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3JARA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:00:57 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:34143 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3JARAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:00:55 -0400
Date: Tue, 1 Oct 2013 14:00:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, eranian@google.com, linux-kernel@vger.kernel.org,
        namhyung.kim@lge.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Fix sorting for 64bit entries
Message-ID: <20131001170044.GG2920@ghostprotocols.net>
References: <1380325164-4478-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380325164-4478-1-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 27, 2013 at 04:39:24PM -0700, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Some of the node comparisons in hist.c dropped the upper
> 32bit by using an int variable to store the compare
> result. This broke various 64bit fields, causing
> incorrect collapsing (found for the TSX transaction field)
> 
> Just use int64_t always.

Thanks, applied.
