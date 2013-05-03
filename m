Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322Ab3ECS67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 14:58:59 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:42510 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763256Ab3ECS66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 14:58:58 -0400
Date: Fri, 3 May 2013 11:58:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cody P Schafer <cody@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] mm: fix comment referring to non-existent
 size_seqlock, change to span_seqlock
In-Reply-To: <1367451121-22725-2-git-send-email-cody@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1305031157280.7526@chino.kir.corp.google.com>
References: <1367451121-22725-1-git-send-email-cody@linux.vnet.ibm.com> <1367451121-22725-2-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Cody P Schafer wrote:

> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>

Others in this series aren't needed, in my opinion, but everybody has 
their own tastes.
