Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaACS0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:26:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52740 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaACS0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:26:09 -0500
Message-ID: <52C700B9.8040504@infradead.org>
Date: Fri, 03 Jan 2014 10:26:01 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, Rasesh Mody <rmody@brocade.com>,
        linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: mmotm 2014-01-02-14-35 uploaded (brocade/bna)
References: <20140102223649.D8FB931C206@corp2gmr1-1.hot.corp.google.com>
In-Reply-To: <20140102223649.D8FB931C206@corp2gmr1-1.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/14 14:36, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2014-01-02-14-35 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 

on i386:

as reported for linux-next of Dec.20, 2013
when CONFIG_NEED_DMA_MAP_STATE is not enabled:

drivers/net/ethernet/brocade/bna/bnad.c: In function 'bnad_start_xmit':
drivers/net/ethernet/brocade/bna/bnad.c:3074:26: error: 'struct bnad_tx_vector' has no member named 'dma_len'



-- 
~Randy
