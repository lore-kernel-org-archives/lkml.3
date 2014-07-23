Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbaGWI2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:28:03 -0400
Received: from mx0.aculab.com ([213.249.233.131]:58753 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757345AbaGWI2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:28:00 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Varka Bhadram'" <varkabhadram@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
CC: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: filter: split filter.c into two files
Thread-Topic: [PATCH net-next 1/2] net: filter: split filter.c into two files
Thread-Index: AQHPpj07lTR5eLRimkOBSY0QWKaPPZutUvJQ
Date: Wed, 23 Jul 2014 08:26:30 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1727BEC0@AcuExch.aculab.com>
References: <1406095319-3627-1-git-send-email-ast@plumgrid.com>
 <1406095319-3627-2-git-send-email-ast@plumgrid.com>
 <53CF522E.9090408@gmail.com>
In-Reply-To: <53CF522E.9090408@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram
> On 07/23/2014 11:31 AM, Alexei Starovoitov wrote:
> > BPF is used in several kernel components. This split creates logical boundary
> > between generic eBPF core and the rest
> >
> > kernel/bpf/core.c: eBPF interpreter
> >
> > net/core/filter.c: classic->eBPF converter, classic verifiers, socket filters
> >
> > This patch only moves functions.
> 
> If we are moving the code also its good to do cleanup.

Except you need to do it as a separate patch.

	David

> Run checkpatch.pl on this...
> 
> 
> --
> Regards,
> Varka Bhadram.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


