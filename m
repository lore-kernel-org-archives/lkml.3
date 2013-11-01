Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3KAWYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:24:47 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:45170 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3KAWYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:24:44 -0400
Message-ID: <52742A2A.9080008@gmail.com>
Date: Fri, 01 Nov 2013 17:24:42 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: manual merge of the dt-rh tree with the powerpc tree
References: <20131101162002.4dd386299ec42e8d8d032be2@canb.auug.org.au>
In-Reply-To: <20131101162002.4dd386299ec42e8d8d032be2@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 12:20 AM, Stephen Rothwell wrote:
> Hi Rob,
> 
> Today's linux-next merge of the dt-rh tree got a conflict in 
> arch/powerpc/include/asm/prom.h between commit a3e31b458844 ("of:
> Move definition of of_find_next_cache_node into common code") from
> the powerpc tree and commit 0c3f061c195c ("of: implement
> of_node_to_nid as a weak function") from the dt-rh tree.

Ben, I can pick these 2 patches up instead if you want to drop them
and avoid the conflict.

Rob

