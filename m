Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaB0POK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:14:10 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:59470 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaB0POJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:14:09 -0500
Message-ID: <1393513614.6784.59.camel@misato.fc.hp.com>
Subject: Re: [PATCH 04/46] kernel: Mark function as static in
 kernel/resource.c
From: Toshi Kani <toshi.kani@hp.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Chen Gong <gong.chen@linux.intel.com>, Kevin Hao <haokexin@gmail.com>,
        josh@joshtriplett.org
Date: Thu, 27 Feb 2014 08:06:54 -0700
In-Reply-To: <c216e1f98b80cff1736617fbf1474ea4dbaa4b4f.1393493276.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
	 <c216e1f98b80cff1736617fbf1474ea4dbaa4b4f.1393493276.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 16:44 +0530, Rashika Kheria wrote:
> Mark function as static in kernel/resource.c because it is not used
> outside this file.
> 
> This eliminates the following warning in kernel/resource.c:
> kernel/resource.c:518:5: warning: no previous prototype for ‘reallocate_resource’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi



