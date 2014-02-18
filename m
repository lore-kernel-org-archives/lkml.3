Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaBRXUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:20:55 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59712 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753131AbaBRXUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:20:53 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Date: Wed, 19 Feb 2014 00:35:43 +0100
Message-ID: <1920764.8Poj9R8nZQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392765307.3488.1.camel@x230.lan>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com> <1511662.Ly2fOjCGKz@vostro.rjw.lan> <1392765307.3488.1.camel@x230.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 18, 2014 11:15:08 PM Matthew Garrett wrote:
> On Wed, 2014-02-19 at 00:26 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, February 18, 2014 11:28:29 AM Matthew Garrett wrote:
> > > 
> > > The ACPI IPMI driver implements IPMI operation region support for the ACPI
> > > core. Systems that declare ACPI operation regions may reference them at any
> > > time, including during kernel initialisation. These accesses will fail
> > > unless the ACPI IPMI driver is present, and undesirable system behaviour
> > > may result. Set the default to Y in order to encourage distributions and
> > > users to configure kernels to avoid awkward surprises.
> > 
> > Do you have any examples of problems caused by that or is this just theoretical
> > at the moment?
> 
> For example, if you load the ACPI power meter driver before you've
> installed the ACPI IPMI driver you'll typically get failures (most
> vendors implement it via IPMI).

Well, any specific machine from any specific vendor?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
