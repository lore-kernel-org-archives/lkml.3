Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaJVBKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:10:19 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:46202 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaJVBKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:10:17 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 21 Oct 2014 18:10:16 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Davide Libenzi <davidel@xmailserver.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] MAP_HUGETLB munmap fails with size not 2MB aligned
In-Reply-To: <alpine.DEB.2.10.1410211047300.16997@davide-lnx3>
Message-ID: <alpine.DEB.2.10.1410211808240.16997@davide-lnx3>
References: <alpine.DEB.2.10.1410211047300.16997@davide-lnx3>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Davide Libenzi wrote:

> Calling mmap with MAP_HUGETLB and a size which is not 2MB aligned, causes 
> mmap to fail. Tested on 3.13.x but tracking back to 3.2.x.

A couple of "un" were found under my desk, as it's clearly munmap which is 
failing.


- Davide


