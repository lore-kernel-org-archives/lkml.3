Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbaGXOCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:02:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:43017 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758778AbaGXOCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:02:14 -0400
Date: Thu, 24 Jul 2014 11:02:04 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: andi@firstfloor.org, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] powerpc/perf: include util/util.h and remove
 stringify macros
Message-ID: <20140724140204.GU20303@kernel.org>
References: <20140724074645.GA18829@us.ibm.com>
 <20140724074718.GB18829@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724074718.GB18829@us.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 24, 2014 at 12:47:18AM -0700, Sukadev Bhattiprolu escreveu:
> [RFC PATCH 1/2] powerpc/perf: include util/util.h and remove stringify macros
> 
> The stringify macros are defined in tools/perf/util/util.h and
> don't need to be redfined specfiically for powerpc.

This one can be picked independelty, done.

- Arnaldo
