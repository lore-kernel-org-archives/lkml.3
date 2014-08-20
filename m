Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaHTGVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:21:50 -0400
Received: from ozlabs.org ([103.22.144.67]:40381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaHTGVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:21:49 -0400
Message-ID: <1408515707.15841.3.camel@concordia>
Subject: Re: [PATCH v3] powerpc/perf: Implement get_cpu_str()
From: Michael Ellerman <mpe@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Aug 2014 16:21:47 +1000
In-Reply-To: <20140819000822.GA9391@us.ibm.com>
References: <20140819000822.GA9391@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-18 at 17:08 -0700, Sukadev Bhattiprolu wrote:
> powerpc/perf: Implement get_cpu_str()
> 
> With a file ~/.cache/pmu-events/004d0100-core.json describing Power8
> PMU events we would need to run:
> 
> 	perf stat \
> 		--events-file ~/.cache/pmu-events/004d0100-core.json \
> 		-e PM_CYC sleep 1
> 
> With this get_cpu_str(), On Powerpc, we can skip the --events-file option
> and run:
> 
> 	perf stat -e PM_CYC sleep 1
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

cheers




