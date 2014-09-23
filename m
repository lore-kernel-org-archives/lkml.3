Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbaIWWPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:15:38 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:51067 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbaIWWPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:15:35 -0400
Date: Tue, 23 Sep 2014 15:15:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sasha Levin <sasha.levin@oracle.com>
cc: akpm@linuxfoundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: build error in dump_mm without CONFIG_COMPACTION
In-Reply-To: <1411440855-27430-1-git-send-email-sasha.levin@oracle.com>
Message-ID: <alpine.DEB.2.02.1409231515130.22630@chino.kir.corp.google.com>
References: <1411440855-27430-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, Sasha Levin wrote:

> In the case of CONFIG_NUMA_BALANCING set and CONFIG_COMPACTION isn't,
> we'd fail to put a "," at the end of the formatting string and cause
> a build failure.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Looks like this is being addressed in http://marc.info/?t=141146436200007.
