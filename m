Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab3BEFbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:31:11 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:47491 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3BEFbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:31:09 -0500
Date: Mon, 4 Feb 2013 21:31:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: liguang <lig.fnst@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 3/4] acpi: add clock_domain field to
 acpi_srat_cpu_affinity
In-Reply-To: <1360031838-26898-4-git-send-email-lig.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1302042127300.31498@chino.kir.corp.google.com>
References: <1360031838-26898-1-git-send-email-lig.fnst@cn.fujitsu.com> <1360031838-26898-4-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, liguang wrote:

> according to ACPI SPEC v5.0, page 152,
> 5.2.16.1 Processor Local APIC/SAPIC Affinity Structure,
> the last member of it is clock_domain.
> 
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
