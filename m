Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbaKORLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 12:11:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbaKORLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 12:11:07 -0500
Message-ID: <5467891B.2010100@redhat.com>
Date: Sat, 15 Nov 2014 12:10:51 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: do not overwrite reserved pages counter at show_mem()
References: <e34cbf786f7c16d4330889825aa5b13141cc085c.1415989668.git.aquini@redhat.com>
In-Reply-To: <e34cbf786f7c16d4330889825aa5b13141cc085c.1415989668.git.aquini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/14/2014 01:34 PM, Rafael Aquini wrote:
> Minor fixlet to perform the reserved pages counter aggregation for
> each node, at show_mem()
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUZ4kbAAoJEM553pKExN6DtgUH/32t89g4pK7Tqgj6jSs2nzGq
AHLma8dL12/JABVPBBqHxwSXCRDF6klCuQPx9v1RMiaksGf4TNNjDnEwDJ65Out4
I0ckZoc2bXRZi9i4IGZEuaAoBjN2CUL2tbgxqQLjO17nLlS+NDJuhtqQzFTE2EyO
uO3wtLBPEtQa7HaBNsElzdauU/pKgT/67s0PtExCTdQAIjLDEqjSI8pT0ltPx0xk
UG9l1ffFy5UhScugoSJDOfbWoZ3YjBZeWwZZ4so4u503TyNOPbucMi8lYyMDMxKd
67SyN2hWb6eKm1d4MXZZwibrbx/YGg/Ngc8kqoC1IDS7Xsl1jPgD3K5IeDMIFFs=
=yglK
-----END PGP SIGNATURE-----
