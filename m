Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbaFLGEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:04:52 -0400
Received: from ja.ssi.bg ([178.16.129.10]:33194 "EHLO ja.home.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751325AbaFLGEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:04:51 -0400
Date: Thu, 12 Jun 2014 09:02:53 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@ja.home.ssi.bg
To: Simon Horman <horms@verge.net.au>
cc: Jet Chen <jet.chen@intel.com>, Wensong Zhang <wensong@linux-vs.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [net/ipvs] BUG: unable to handle kernel NULL pointer dereference
 at 00000004
In-Reply-To: <20140612034633.GH22273@verge.net.au>
Message-ID: <alpine.LFD.2.11.1406120900350.1769@ja.home.ssi.bg>
References: <5397DE0E.2070501@intel.com> <alpine.LFD.2.11.1406110828460.2070@ja.home.ssi.bg> <5398148B.603@intel.com> <20140612034633.GH22273@verge.net.au>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Thu, 12 Jun 2014, Simon Horman wrote:

> Thanks, Julian, should I take this one?
> I'm assuming this problem has been present for quite a number of releases.

	I'll post new version with extended comments.

Regards

--
Julian Anastasov <ja@ssi.bg>
