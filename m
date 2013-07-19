Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab3GSNzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:55:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47664 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3GSNy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:54:59 -0400
Date: Fri, 19 Jul 2013 09:54:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <daniel.kiper@oracle.com>, olaf@aepfle.de
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Brandon Philips <brandon@ifup.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: is kexec on Xen domU possible?
Message-ID: <20130719135445.GB12144@localhost.localdomain>
References: <20130719020603.GA22932@kroah.com>
 <20130719131819.GC11233@debian70-amd64.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719131819.GC11233@debian70-amd64.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Daniel,

Thank you for the nice summary.

>   - PVonHVM guests: IIRC, there were some issues with PV
>     drivers but they were fixed some time ago by patches
>     posted by Olaf Hering,

Which had to be reverted b/c they caused regressions with
32-bit guests during migration. But Greg if you are just looking
to do it on a guest without migration then cherrypicking
 9d02b43dee0d7fb18dfb13a00915550b1a3daa9f
("xen PVonHVM: use E820_Reserved area for shared_info")
should do it for it.

Olaf, you wouldn't have any time to look at this some more now
that Xen 4.3 is out?
