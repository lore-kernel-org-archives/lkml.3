Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbbA2BfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:35:20 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59635 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754188AbbA2BfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:35:11 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Yaowei Bai <bywxiaobai@163.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/acpi: add the missing '='
Date: Thu, 29 Jan 2015 02:57:57 +0100
Message-ID: <3096114.ORU24SZqu9@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150128150408.7c76ce05@lwn.net>
References: <1421330356-4051-1-git-send-email-bywxiaobai@163.com> <2132979.yiiZbQ1huf@vostro.rjw.lan> <20150128150408.7c76ce05@lwn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 28, 2015 03:04:08 PM Jonathan Corbet wrote:
> On Wed, 28 Jan 2015 21:12:36 +0100
> "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> 
> > > On Thu, 15 Jan 2015 21:59:16 +0800
> > > Yaowei Bai <bywxiaobai@163.com> wrote:
> > >   
> > > > -			.acpi_match_table  ACPI_PTR(mpu3050_acpi_match),
> > > > +			.acpi_match_table = ACPI_PTR(mpu3050_acpi_match),  
> > > 
> > > Applied to the docs tree, thanks.  
> > 
> > I've applied this one too.  Should I drop it?
> 
> I'll drop it, no worries.

OK, thanks!

