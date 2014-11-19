Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbaKSWjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:39:32 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54099 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbaKSWjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:39:17 -0500
Date: Wed, 19 Nov 2014 14:39:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luiz Capitulino <lcapitulino@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, andi@firstfloor.org, riel@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org, davidlohr@hp.com
Subject: Re: [PATCH 1/3] hugetlb: fix hugepages= entry in
 kernel-parameters.txt
In-Reply-To: <1415831593-9020-2-git-send-email-lcapitulino@redhat.com>
Message-ID: <alpine.DEB.2.10.1411191439030.24691@chino.kir.corp.google.com>
References: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com> <1415831593-9020-2-git-send-email-lcapitulino@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Luiz Capitulino wrote:

> The hugepages= entry in kernel-parameters.txt states that
> 1GB pages can only be allocated at boot time and not
> freed afterwards. This is not true since commit
> 944d9fec8d7aee, at least for x86_64.
> 
> Instead of adding arch-specifc observations to the
> hugepages= entry, this commit just drops the out of date
> information. Further information about arch-specific
> support and available features can be obtained in the
> hugetlb documentation.
> 
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>
