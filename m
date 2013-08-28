Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3H1OYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:24:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab3H1OYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:24:19 -0400
Date: Wed, 28 Aug 2013 11:23:04 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com, peterz@infradead.org,
        mingo@elte.hu, sukadev@linux.vnet.ibm.com, ak@linux.intel.com,
        jolsa@redhat.com
Subject: Re: [PATCH v2] perf mem: add priv level filtering support
Message-ID: <20130828142304.GF3825@infradead.org>
References: <20130828141136.GA1549@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828141136.GA1549@quad>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 28, 2013 at 04:11:36PM +0200, Stephane Eranian escreveu:
> +-K::
> +	Only sample loads/stores at the kernel level (default: user + kernel)
> +
> +-U::
> +	Only sample loads/stores at the user level (default: user + kernel)
> +

Mid air collision, perfect, this is even better than what I suggested
before reading this message, as it adds that default clarification,
thanks, applying.

- Arnaldo
