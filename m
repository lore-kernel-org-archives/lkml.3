Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaFDRRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:17:00 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:58551
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbaFDRQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:16:59 -0400
Date: Wed, 4 Jun 2014 12:16:56 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] last minute percpu fix for v3.15-rc8
In-Reply-To: <20140604163700.GH5004@htj.dyndns.org>
Message-ID: <alpine.DEB.2.10.1406041215180.12469@gentwo.org>
References: <20140604163700.GH5004@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Tejun Heo wrote:

> I'll ping Christoph whether __this_cpu_*() ops can be better annotated
> so that it can trigger lockdep warning when used from multiple
> contexts.

We just added checks that verify the proper preemption mode for
__this_cpu operations. That did not catch it?

