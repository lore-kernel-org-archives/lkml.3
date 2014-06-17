Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaFQAYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:24:17 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:45851 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaFQAYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:24:15 -0400
Date: Mon, 16 Jun 2014 17:24:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Jaeger <christophjaeger@linux.com>
cc: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: use kstrto*() instead of simple_strto*()
In-Reply-To: <1402688998-20142-1-git-send-email-christophjaeger@linux.com>
Message-ID: <alpine.DEB.2.02.1406161724020.21018@chino.kir.corp.google.com>
References: <1402688998-20142-1-git-send-email-christophjaeger@linux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Christoph Jaeger wrote:

> simple_strto*() are obsolete; use kstrto*() instead. Add proper error
> checking.
> 
> Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>

Acked-by: David Rientjes <rientjes@google.com>
