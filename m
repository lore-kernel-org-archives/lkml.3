Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3HUMlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:41:10 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53237 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab3HUMlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:41:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: bgrt: take advantage of binary sysfs groups
Date: Wed, 21 Aug 2013 14:51:40 +0200
Message-ID: <3825729.FGg1e4OV3U@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130821001149.GA16350@kroah.com>
References: <20130821001149.GA16350@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 05:11:49 PM Greg KH wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
> Attribute groups now can handle binary sysfs attributes, so clean up the
> code here by using a binary attribute array.  This saves us the extra
> call to create the binary attribute at saves 6 lines overall.
> 
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

