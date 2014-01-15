Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaAOBbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:31:43 -0500
Received: from mail-gg0-f176.google.com ([209.85.161.176]:48146 "EHLO
	mail-gg0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaAOBbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:31:41 -0500
Date: Tue, 14 Jan 2014 17:31:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: William Roberts <bill.c.roberts@gmail.com>
cc: linux-audit@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rgb@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        sds@tycho.nsa.gov, William Roberts <wroberts@tresys.com>
Subject: Re: [RFC][PATCH v2 1/3] mm: Create utility function for accessing
 a tasks commandline value
In-Reply-To: <1389632555-7039-1-git-send-email-wroberts@tresys.com>
Message-ID: <alpine.DEB.2.02.1401141731210.32645@chino.kir.corp.google.com>
References: <1389632555-7039-1-git-send-email-wroberts@tresys.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jan 2014, William Roberts wrote:

> introduce get_cmdline() for retreiving the value of a processes
> proc/self/cmdline value.
> 
> Signed-off-by: William Roberts <wroberts@tresys.com>

Acked-by: David Rientjes <rientjes@google.com>
