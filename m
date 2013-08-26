Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab3HZVPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:15:54 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:56815 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712Ab3HZVPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:15:53 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 17:15:52 EDT
Date: Mon, 26 Aug 2013 21:06:16 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: akpm@linuxfoundation.org, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [guv v2 02/31] percpu: Make __verify_pcu_ptr handle per cpu
 pointers to arrays
In-Reply-To: <00000140bc5bf84a-56dd6082-f1d6-4cee-b8dd-cc4e5c27a911-000000@email.amazonses.com>
Message-ID: <00000140bc72d488-cede7e7a-fef2-41a6-8355-2dc481b6b665-000000@email.amazonses.com>
References: <20130826204138.307369532@linux.com> <00000140bc5bf84a-56dd6082-f1d6-4cee-b8dd-cc4e5c27a911-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about the dups. I had an " missing in an CC statement which caused
the mailer to continue to allocate memory until it went oom.

