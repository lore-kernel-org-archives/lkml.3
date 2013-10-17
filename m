Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab3JQQKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:10:47 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:40104 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579Ab3JQQKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <1382000112.22110.103.camel@joe-AO722>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
	<1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
	<1381978749.22110.76.camel@joe-AO722>
	<20131017063059.GB14946@gchen.bj.intel.com>
	<1381993136.22110.95.camel@joe-AO722>
	<20131017073824.GC14946@gchen.bj.intel.com>
	<1381998750.22110.101.camel@joe-AO722>
	<20131017084014.GD5036@pd.tnic>
	<1382000112.22110.103.camel@joe-AO722>
Date: Thu, 17 Oct 2013 09:10:40 -0700
Message-ID: <CA+8MBbLDVJgY9WWTY6vPeY7+L04-xDPofJ9eLwh7dJipBBh51w@mail.gmail.com>
Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
From: Tony Luck <tony.luck@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Borislav Petkov <bp@alien8.de>, Chen Gong <gong.chen@linux.intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        m.chehab@samsung.com, arozansk@redhat.com,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 1:55 AM, Joe Perches <joe@perches.com> wrote:
> It's cost free to add the BUILD_BUG_ON
> and perhaps you underestimate the runtime
> bug checking effort,

This looks OK to me.  Gong: This doesn't stop people from using variables
as arguments ... they just won't get a check for (h) < (l).

-Tony
