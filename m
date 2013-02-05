Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015Ab3BEFUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:20:38 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36192 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3BEFUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:20:37 -0500
Date: Mon, 4 Feb 2013 21:20:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: liguang <lig.fnst@cn.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] mm: break circular include from linux/mmzone.h
In-Reply-To: <1360037707-13935-1-git-send-email-lig.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1302042119370.31498@chino.kir.corp.google.com>
References: <1360037707-13935-1-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, liguang wrote:

> linux/mmzone.h included linux/memory_hotplug.h,
> and linux/memory_hotplug.h also included
> linux/mmzone.h, so there's a bad cirlular.
> 

And both of these are protected by _LINUX_MMZONE_H and 
__LINUX_MEMORY_HOTPLUG_H, respectively, so what's the problem?
