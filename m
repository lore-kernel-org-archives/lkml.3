Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbaKSWmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:42:06 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34907 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467AbaKSWmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:42:03 -0500
Date: Wed, 19 Nov 2014 14:42:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luiz Capitulino <lcapitulino@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, andi@firstfloor.org, riel@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org, davidlohr@hp.com
Subject: Re: [PATCH 2/3] hugetlb: alloc_bootmem_huge_page(): use
 IS_ALIGNED()
In-Reply-To: <1415831593-9020-3-git-send-email-lcapitulino@redhat.com>
Message-ID: <alpine.DEB.2.10.1411191441450.24691@chino.kir.corp.google.com>
References: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com> <1415831593-9020-3-git-send-email-lcapitulino@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Luiz Capitulino wrote:

> No reason to duplicate the code of an existing macro.
> 
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>
