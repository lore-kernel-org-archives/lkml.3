Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaBHK3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 05:29:50 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45328 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaBHK3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 05:29:49 -0500
Date: Sat, 8 Feb 2014 02:29:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@linux.intel.com>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, sections, numachip: Remove useless __read_mostly
In-Reply-To: <1391846045-28661-1-git-send-email-ak@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1402080229340.11484@chino.kir.corp.google.com>
References: <1391846045-28661-1-git-send-email-ak@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Feb 2014, Andi Kleen wrote:

> const __read_mostly does not make any sense, because const
> data is already read-only. Remove the __read_mostly
> for the numachip APIC driver. This avoids a LTO
> section conflict compile problem.
> 
> Cc: x86@kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: David Rientjes <rientjes@google.com>
