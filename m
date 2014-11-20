Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbaKTAun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:50:43 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55979 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaKTAum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:50:42 -0500
Date: Wed, 19 Nov 2014 16:50:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
cc: akpm@linux-foundation.org, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa balancing: Rearrange Kconfig entry
In-Reply-To: <1413425935-24767-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.10.1411191650180.9079@chino.kir.corp.google.com>
References: <1413425935-24767-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014, Aneesh Kumar K.V wrote:

> Add the default enable config option after the NUMA_BALANCING option
> so that it appears related in the nconfig interface.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>

Hasn't hit Linus's tree yet, so there's still time to ack!
