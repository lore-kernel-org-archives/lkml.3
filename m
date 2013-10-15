Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847Ab3JOUxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:53:17 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59969 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759654Ab3JOUxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:53:15 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] ACPI/Power: Fix infinite loop of runtime resume and suspend caused by turning on power resource
Date: Tue, 15 Oct 2013 23:05:04 +0200
Message-ID: <1957403.qYMK7iKccF@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1381849493-7977-1-git-send-email-tianyu.lan@intel.com>
References: <1381849493-7977-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 15, 2013 11:04:50 PM Lan Tianyu wrote:
> Currently, clearing usb port(empty port) PM Qos NO_POWER_OFF flag twice will lead
> the usb port to fall into the infinite loop of runtime pm resume and
> suspend. This is caused by pm_request_resume() in the acpi_power_resume_dependent().
> Detail is in the following link.
> http://marc.info/?l=linux-acpi&m=138182749202885&w=2

As far as I can say, the bug is in USB, so I'm not quite sure why you want
to address it in the ACPI core?

Rafael

