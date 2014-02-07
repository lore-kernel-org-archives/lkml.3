Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaBGUtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:49:17 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:46193 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaBGUtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:49:15 -0500
Date: Fri, 7 Feb 2014 12:49:13 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rashika Kheria <rashika.kheria@gmail.com>
cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 4/9] mm: Mark function as static in process_vm_access.c
In-Reply-To: <cd2e33f9fd5b160ef5108273d7dbabd8259c4f07.1391167128.git.rashika.kheria@gmail.com>
Message-ID: <alpine.DEB.2.02.1402071249040.4212@chino.kir.corp.google.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com> <cd2e33f9fd5b160ef5108273d7dbabd8259c4f07.1391167128.git.rashika.kheria@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1762423510-1391806154=:4212"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1762423510-1391806154=:4212
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 7 Feb 2014, Rashika Kheria wrote:

> Mark function as static in process_vm_access.c because it is not used
> outside this file.
> 
> This eliminates the following warning in mm/process_vm_access.c:
> mm/process_vm_access.c:416:1: warning: no previous prototype for ‘compat_process_vm_rw’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: David Rientjes <rientjes@google.com>
--531381512-1762423510-1391806154=:4212--
