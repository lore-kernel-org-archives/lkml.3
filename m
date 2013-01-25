Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab3AYVed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 16:34:33 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:58580 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3AYVea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 16:34:30 -0500
Date: Fri, 25 Jan 2013 13:34:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] sysfs: Fix build when sysfs is disabled
In-Reply-To: <2337783.BBmzZI9Lts@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.00.1301251334090.25226@chino.kir.corp.google.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <1511541.AH8DLsNQJH@vostro.rjw.lan> <alpine.DEB.2.00.1301251211410.3815@chino.kir.corp.google.com> <2337783.BBmzZI9Lts@vostro.rjw.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013, Rafael J. Wysocki wrote:

> Can you please send me the .config that triggered those errors?  It will be
> useful for future build testing.
> 

Anything with CONFIG_SYSFS disabled.
