Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaE1ASO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:18:14 -0400
Received: from one.firstfloor.org ([193.170.194.197]:54612 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaE1ASN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:18:13 -0400
Date: Wed, 28 May 2014 02:18:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Support spark lines in perf stat v2
Message-ID: <20140528001810.GG25366@two.firstfloor.org>
References: <1399935686-26940-1-git-send-email-andi@firstfloor.org>
 <20140526173348.GA7657@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526173348.GA7657@krava.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> ok.. confusing.. so this v2 has changes which are missing in v3 patch:
> http://marc.info/?l=linux-kernel&m=139767371027557&w=2

What do you think is missing? I removed some code Namhyung didn't like
in v3

-Andi
