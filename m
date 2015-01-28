Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbbA2BKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:10:54 -0500
Received: from tex.lwn.net ([70.33.254.29]:35863 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbbA2BKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:10:51 -0500
Date: Wed, 28 Jan 2015 15:04:08 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Yaowei Bai <bywxiaobai@163.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/acpi: add the missing '='
Message-ID: <20150128150408.7c76ce05@lwn.net>
In-Reply-To: <2132979.yiiZbQ1huf@vostro.rjw.lan>
References: <1421330356-4051-1-git-send-email-bywxiaobai@163.com>
	<20150128120850.5f6504a7@lwn.net>
	<2132979.yiiZbQ1huf@vostro.rjw.lan>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015 21:12:36 +0100
"Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:

> > On Thu, 15 Jan 2015 21:59:16 +0800
> > Yaowei Bai <bywxiaobai@163.com> wrote:
> >   
> > > -			.acpi_match_table  ACPI_PTR(mpu3050_acpi_match),
> > > +			.acpi_match_table = ACPI_PTR(mpu3050_acpi_match),  
> > 
> > Applied to the docs tree, thanks.  
> 
> I've applied this one too.  Should I drop it?

I'll drop it, no worries.

jon
