Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3LDMKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:10:23 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13923 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3LDMKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:10:22 -0500
X-IronPort-AV: E=Sophos;i="4.93,824,1378857600"; 
   d="scan'208";a="78112462"
Message-ID: <1386159015.17466.60.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Roger Pau Monne <roger.pau@citrix.com>
Date: Wed, 4 Dec 2013 12:10:15 +0000
In-Reply-To: <1386149319.13256.83.camel@kazak.uk.xensource.com>
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
	 <529DBA07.6090108@citrix.com>
	 <1386068884.13256.9.camel@kazak.uk.xensource.com>
	 <529DC7BA.7080506@citrix.com>
	 <1386078108.13256.30.camel@kazak.uk.xensource.com>
	 <529DF4A0.50103@citrix.com>
	 <1386083821.13256.42.camel@kazak.uk.xensource.com>
	 <20131203201135.GA14243@phenom.dumpdata.com>
	 <1386149319.13256.83.camel@kazak.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 09:28 +0000, Ian Campbell wrote:
> This could probably even be semi automated by producing a script to feed
> to gdb which run through all of the options and diffing the result.
> 
> If I could have the moon on a stick I would have a tool such as this
> running against the canonical Xen headers, to catch breakage as it is
> introduced upstream and a tool which could run against an arbitrary ELF
> binary to validate it against the upstream results.
> tools/include/xen-foreign/mkchecker.py goes some way towards that but
> isn't really extensible to the extent we would need/want.

Perhaps the gdb python extensions are what we need:
http://stackoverflow.com/questions/9788679/how-to-get-the-relative-adress-of-a-field-in-a-structure-dump-c

or perhaps
http://turtle.ee.ncku.edu.tw/docs/perl/manual/utils/c2ph.html



