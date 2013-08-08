Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966022Ab3HHTei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:34:38 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:28105 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965496Ab3HHTeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:34:36 -0400
Message-ID: <1375990405.10300.213.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/2] ACPI: More acpi_bind_one() cleanups
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Date: Thu, 08 Aug 2013 13:33:25 -0600
In-Reply-To: <5685060.iNWFUGc9at@vostro.rjw.lan>
References: <5685060.iNWFUGc9at@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 01:54 +0200, Rafael J. Wysocki wrote:
> Hi All,
> 
> Two more cleanups for acpi_bind_one() on top of linux-pm.git/linux-next
> follow:
> 
> [1/2] Drop unnecessary label from acpi_bind_one().
> [2/2] Print diagnostic messages if device links cannot be created.

Looks good.

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

