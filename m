Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760Ab3BSVZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 16:25:14 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:39227 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932Ab3BSVZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 16:25:12 -0500
Date: Tue, 19 Feb 2013 13:25:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: liguang <lig.fnst@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH v4 2/4] numa: avoid export acpi_numa variable
In-Reply-To: <1360894992-14818-3-git-send-email-lig.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1302191324520.6322@chino.kir.corp.google.com>
References: <1360894992-14818-1-git-send-email-lig.fnst@cn.fujitsu.com> <1360894992-14818-3-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013, liguang wrote:

> acpi_numa is used to prevent srat table
> being parsed, seems a little miss-named,
> if 'noacpi' was specified by cmdline and
> CONFIG_ACPI_NUMA was enabled, acpi_numa
> will be operated directly from everywhere
> it needed to disable/enable numa in acpi
> mode which was a bad thing, so, try to
> export a fuction to get srat table
> enable/disable info.
> 
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
