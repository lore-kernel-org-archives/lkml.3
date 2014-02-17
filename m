Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaBQScT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:32:19 -0500
Received: from www.meduna.org ([92.240.244.38]:37905 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbaBQScS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:32:18 -0500
Message-ID: <530255AA.2080905@meduna.org>
Date: Mon, 17 Feb 2014 19:32:10 +0100
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        hjk@hansjkoch.de
Subject: Re: UIO and memory from dma_alloc_coherent - UIO_MEM_PHYS?
References: <53024FAD.2000709@meduna.org> <20140217181854.GA7119@kroah.com>
In-Reply-To: <20140217181854.GA7119@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-02-17 19:32:15
X-Connected-IP: 95.105.163.217:28641
X-Message-Linecount: 32
X-Body-Linecount: 17
X-Message-Size: 1187
X-Body-Size: 536
X-Received-Count: 1
X-Recipient-Count: 3
X-Local-Recipient-Count: 3
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.02.2014 19:18, Greg KH wrote:

> The uio_dmem_genirq.c driver showed up in 3.8, so it might be good for
> you to update your kernel if you want to do DMA memory with a UIO
> driver, as lots of other things in this area was fixed to accomplish
> this.

Ah, OK, I will look into this.

I am stuck with 3.4 at the moment because of the real-time patches
and some semantic changes there in the newer kernels necessitating
much more tweak-and-test time than I currently have...

Thanks
-- 
                                      Stano

