Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaHANyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:54:55 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:45340
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbaHANyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:54:54 -0400
Date: Fri, 1 Aug 2014 08:54:51 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Fengguang Wu <fengguang.wu@intel.com>
cc: Tejun Heo <tj@kernel.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [scheduler] BUG: unable to handle kernel paging request at
 000000000000ce50
In-Reply-To: <20140731104226.GB9455@localhost>
Message-ID: <alpine.DEB.2.11.1408010853570.19843@gentwo.org>
References: <20140730135616.GK16537@localhost> <alpine.DEB.2.11.1407300954420.4608@gentwo.org> <20140731104226.GB9455@localhost>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Fengguang Wu wrote:

> Sorry I find that next-20140730 no long show the BUG. So there is no
> way to test whether this patch fixed the problem.

I guess this means that the bug was unrelated to this patch. Nevertheless
I think this patch cleans up two minor issues.
