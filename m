Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbaKSWnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:43:43 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33200 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbaKSWnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:43:41 -0500
Date: Wed, 19 Nov 2014 14:43:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luiz Capitulino <lcapitulino@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, andi@firstfloor.org, riel@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org, davidlohr@hp.com
Subject: Re: [PATCH 3/3] hugetlb: hugetlb_register_all_nodes(): add __init
 marker
In-Reply-To: <1415831593-9020-4-git-send-email-lcapitulino@redhat.com>
Message-ID: <alpine.DEB.2.10.1411191442580.24691@chino.kir.corp.google.com>
References: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com> <1415831593-9020-4-git-send-email-lcapitulino@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Luiz Capitulino wrote:

> This function is only called during initialization.
> 
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>

And hugetlb_unregister_all_nodes() could be __exit.  The !CONFIG_NUMA 
versions would be better off inline.
