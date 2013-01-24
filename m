Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab3AXJKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:10:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3AXJKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:10:05 -0500
Message-ID: <1359018455.5833.64.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Thu, 24 Jan 2013 10:07:35 +0100
In-Reply-To: <5100ED7A.303@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50FD08E1.8000302@linux.vnet.ibm.com>
	 <1358761496.4994.118.camel@marge.simpson.net>
	 <50FE0ADC.6060701@linux.vnet.ibm.com>
	 <1358841795.5782.255.camel@marge.simpson.net>
	 <50FE5433.1070801@linux.vnet.ibm.com>
	 <1358865692.5782.420.camel@marge.simpson.net>
	 <50FF4EA0.1070000@linux.vnet.ibm.com>
	 <1358915494.5752.46.camel@marge.simpson.net>
	 <50FF7086.4020509@linux.vnet.ibm.com>
	 <1358922520.5752.91.camel@marge.simpson.net>
	 <50FF8CD8.4060105@linux.vnet.ibm.com>
	 <1358929257.5752.109.camel@marge.simp! son.net>
	 <50FF9F92.60202@linux.vnet.ibm.com>
	 <1358930968.5752.123.camel@marge.simpson.net>
	 <50FFA695.6010407@linux.vnet.ibm.com>
	 <1358932694.5752.126.camel@marge.simpson.net>
	 <1358933555.5752.132.camel@marge.simpson.net>
	 <5100CE1F.7080704@linux.vnet.ibm.com>
	 <1359010272.5833.39.camel@marge.simpson.net>
	 <5100DF95.3020909@linux.vnet.ibm.com>
	 <1359013623.5833.52.camel@marge.simpson.net>
	 <5100ED7A.303@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:/ro0Zryp0o1rCs3OP8IifcSDAAh0OdtRZFn2UJfD+cF
 6hy+W2FnV14IxU+sJkb9PiJserD0MSOgmLeux60kCXRw1bZX22
 EzwLKO55xJWW6ELH+67odFB4zLsopMsw6BpITEG9EWHucd9/X/
 dXvZtD1tt14hzPn3rE+p9tn6h0CiIjaNoRYLqd/BfmkMPJNOfQ
 lHEnzhbPhk+3dqrR1raAB0bZnxBY42bCGuNG50p/ERf2+UZtBB
 y9VXbrU/2tj2ecgOLcU87Yd/+mdFdwHS/+UO6Y98NoxovLePwG
 sPDxqQMeS4GdS0KQbO0TXJ8WHIDsPKRECEwkh7pfYD7d+Kgoqc
 FBi9sOjCivybx/kHWnpZ4pytV8PHWl0QTcEEJmY5rxpxuDpgeD
 qrKtWboxtR1bA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 16:14 +0800, Michael Wang wrote:

> Now it's time to work on v3 I think, let's see what we could get this time.

Maybe v3 can try to not waste so much ram on affine map?

Even better would be if it could just go away, along with relic of the
bad old days wake_affine(), and we make the balance path so damn light
but clever that select_idle_sibling() can go away too... and a pony ;-)

-Mike

