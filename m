Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbaAVDCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 22:02:14 -0500
Received: from mail-gg0-f169.google.com ([209.85.161.169]:58863 "EHLO
	mail-gg0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaAVDCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 22:02:10 -0500
Date: Tue, 21 Jan 2014 19:02:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Frysinger <vapier@gentoo.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] uapi: convert u64 to __u64 in exported headers
In-Reply-To: <1390358426-8884-1-git-send-email-vapier@gentoo.org>
Message-ID: <alpine.DEB.2.02.1401211901560.18749@chino.kir.corp.google.com>
References: <1390358426-8884-1-git-send-email-vapier@gentoo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014, Mike Frysinger wrote:

> The u64 type is not defined in any exported kernel headers, so trying
> to use it will lead to build failures.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: David Rientjes <rientjes@google.com>
