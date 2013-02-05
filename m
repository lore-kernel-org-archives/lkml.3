Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3BEFmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:42:43 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:48243 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab3BEFml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:42:41 -0500
Date: Mon, 4 Feb 2013 21:42:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: liguang <lig.fnst@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 4/4] remove include asm/acpi.h in process_driver.c
In-Reply-To: <1360031838-26898-5-git-send-email-lig.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1302042142280.31498@chino.kir.corp.google.com>
References: <1360031838-26898-1-git-send-email-lig.fnst@cn.fujitsu.com> <1360031838-26898-5-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, liguang wrote:

> process_driver.c include linux/acpi.h which already
> include asm/acpi.h, so remove it.
> 
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
