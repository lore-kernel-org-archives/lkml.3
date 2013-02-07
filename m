Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3BGEJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:09:28 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34288 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3BGEJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:09:27 -0500
Date: Wed, 6 Feb 2013 23:09:23 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        js1304@gmail.com, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v6 0/3] introduce static_vm for ARM-specific static mapped
 area
In-Reply-To: <1360142010-10598-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.LFD.2.02.1302062304490.6300@xanadu.home>
References: <1360142010-10598-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013, Joonsoo Kim wrote:

> Changelog
> v5->v6:
>   Add Ack-by, Reviewed-by, Tested-by tags
>   [3/3]: Change from Nicolas' suggestion
>   	 - remove redundant parenthesis

This looks all fine now.  Please submit your patches here for RMK to 
merge: http://www.arm.linux.org.uk/developer/patches/


Nicolas
