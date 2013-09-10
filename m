Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab3IJIyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:54:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49686 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3IJIx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:53:58 -0400
Message-ID: <1378803212.6046.86.camel@marge.simpson.net>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
From: Mike Galbraith <bitbucket@online.de>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 10 Sep 2013 10:53:32 +0200
In-Reply-To: <CAOtvUMdRmDYP_e7eFX1akU8vZ=dcVOnFDrBjKufumOaBxxXF3A@mail.gmail.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
	 <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
	 <1378795659.6046.41.camel@marge.simpson.net>
	 <CAOtvUMfhLQYK95uPm8idG_vYv-9yG2-KSkScjMBCSuvtffW1Dg@mail.gmail.com>
	 <1378797995.6046.54.camel@marge.simpson.net>
	 <CAOtvUMdRmDYP_e7eFX1akU8vZ=dcVOnFDrBjKufumOaBxxXF3A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:KH7RniiwB0p2JZoFJ7fcq9yxfGRh3Ns6YCwluG5kC1U
 ltoSZooMkGBcGLOx8zu5URoT08MJyijzMWQ3fbsX8d3ep31yYX
 k+nFRNs1ITsD735GyAxX+IXTAGQcnkGNpetA5RY97REJ2dHXj6
 50L+WfMVTqVMt5theXgMo4fRDPFYcZ/x5iuIJAVASD2xf4GLkh
 9jqj7GgYNpe5pvXUc6PcxoHx+EhXqwRRWHc2qC6MiOYCKFjq5S
 /tWhVodPFtVJ/OZhNNnRivDMlF1UVw60rl/H5BS7QlOKJm9qkX
 3vTme8SZI4vJdV0V52MMRrxjRzpALYWPhXSFf+zZLskxXBY4U/
 jUWZyGhZIfNdsy5EjNCkET0rK5kF/LZ5MwVnZH8H4L+xBhtIVq
 cJVxsCpwwBvLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-10 at 10:56 +0300, Gilad Ben-Yossef wrote:

> What if we  re-did the implementation of isolcpu as creating an
> cpuset with migration off as early as possible in the boot process, prior to
> spawning init?
> 
> So basically, isolcpus becomes just a way to configure a cpuset early?

Makes perfect sense to me.

-Mike

