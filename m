Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaFDS2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:28:13 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:53756 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbaFDS2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:28:12 -0400
Date: Wed, 4 Jun 2014 13:28:09 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] last minute percpu fix for v3.15-rc8
In-Reply-To: <20140604181214.GM5004@htj.dyndns.org>
Message-ID: <alpine.DEB.2.10.1406041327240.12812@gentwo.org>
References: <20140604163700.GH5004@htj.dyndns.org> <alpine.DEB.2.10.1406041215180.12469@gentwo.org> <20140604181214.GM5004@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Tejun Heo wrote:

>
> Given that percpu operations can be performed on any allocated percpu
> area, it's a bit difficult to achieve tho.  The only way I can think
> of is percpu allocator creating lockdep key for all the allocated
> offsets which isn't too enticing. :(

Hmmm.. Or an annotation for a percpu variable saying that its being used
from an interrupt context.

