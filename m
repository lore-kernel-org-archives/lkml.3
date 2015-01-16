Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbbAPHso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:48:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbbAPHsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:48:43 -0500
Date: Fri, 16 Jan 2015 08:48:35 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use dwfl_report_elf() instead of offline
Message-ID: <20150116074835.GA2658@krava.brq.redhat.com>
References: <20150114221045.GA17703@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114221045.GA17703@us.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 02:10:45PM -0800, Sukadev Bhattiprolu wrote:
> 
> From 8e6fb4c58d0d9f4798c191d840e32084b1217cc3 Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Fri, 21 Nov 2014 20:33:53 -0500
> Subject: [PATCH 1/1] Use dwfl_report_elf() instead of offline.
> 
> dwfl_report_offline() works only when libraries are prelinked.
> 
> Replace dwfl_report_offline() with dwfl_report_elf() so we correctly
> extract debug info even from libraries that are not prelinked.
> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Tested-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
