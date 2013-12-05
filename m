Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3LEXMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:12:25 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:49419 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3LEXMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:12:23 -0500
Date: Thu, 5 Dec 2013 15:12:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sima Baymani <sima.baymani@gmail.com>
cc: linux-mm@kvack.org, tangchen@cn.fujitsu.com, akpm@linux-foundation.org,
        aquini@redhat.com, linux-kernel@vger.kernel.org, gang.chen@asianux.com,
        aneesh.kumar@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        kirill.shutemov@linux.intel.com, sjenning@linux.vnet.ibm.com,
        darrick.wong@oracle.com
Subject: Re: [PATCH] mm: Add missing dependency in Kconfig
In-Reply-To: <20131205193050.GA13476@lovelace>
Message-ID: <alpine.DEB.2.02.1312051512050.7717@chino.kir.corp.google.com>
References: <20131205193050.GA13476@lovelace>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013, Sima Baymani wrote:

> Eliminate the following (rand)config warning by adding missing PROC_FS
> dependency:
> warning: (HWPOISON_INJECT && MEM_SOFT_DIRTY) selects PROC_PAGE_MONITOR
> which has unmet direct dependencies (PROC_FS && MMU)
> 
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Sima Baymani <sima.baymani@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
