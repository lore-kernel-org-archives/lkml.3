Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaBPUoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 15:44:14 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:59526 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbaBPUoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:44:13 -0500
Message-ID: <1392583450.28866.91.camel@x220>
Subject: Re: [PATCH] acpi: Remove Kconfig symbol ACPI_PROCFS
From: Paul Bolle <pebolle@tiscali.nl>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 21:44:10 +0100
In-Reply-To: <49750510.SeydVA5ctE@vostro.rjw.lan>
References: <1392570485.28866.10.camel@x220>
	 <49750510.SeydVA5ctE@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 20:44:11.0247 (UTC) FILETIME=[D88F8FF0:01CF2B57]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-16 at 21:45 +0100, Rafael J. Wysocki wrote:
> Some defconfigs set it.  Care to remove it from them too?

As in: send a v2 which also strips it from those defconfigs? Fine with
me.

(Side note: I've learned to ignore the defconfigs. They have accumulated
a lot of cruft. I once sent a pull request to clean all defconfigs. It
was ignored and I was rather fed up with doing trying to clean up
defconfigs, so I never sent out an updated pull request.)


Paul Bolle

