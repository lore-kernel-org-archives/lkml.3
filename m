Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab3K3Bls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 20:41:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55602 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3K3Blp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 20:41:45 -0500
Message-ID: <52994255.4000800@infradead.org>
Date: Fri, 29 Nov 2013 17:41:41 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        sfi-devel@simplefirmware.org
Subject: Re: linux-next: Tree for Nov 29 (sfi)
References: <20131129134535.f886fbf966dcfea00178a1b7@canb.auug.org.au>
In-Reply-To: <20131129134535.f886fbf966dcfea00178a1b7@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/13 18:45, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20131128:
> 

on x86_64:

when CONFIG_ACPI is not enabled:

  CC      drivers/sfi/sfi_acpi.o
drivers/sfi/sfi_acpi.c: In function 'sfi_acpi_parse_xsdt':
drivers/sfi/sfi_acpi.c:105:12: error: dereferencing pointer to incomplete type
drivers/sfi/sfi_acpi.c:105:12: error: invalid application of 'sizeof' to incomplete type 'struct acpi_table_header'
drivers/sfi/sfi_acpi.c:107:32: error: dereferencing pointer to incomplete type
drivers/sfi/sfi_acpi.c: In function 'sfi_acpi_get_table':
drivers/sfi/sfi_acpi.c:133:12: error: dereferencing pointer to incomplete type
drivers/sfi/sfi_acpi.c:133:12: error: invalid application of 'sizeof' to incomplete type 'struct acpi_table_header'
drivers/sfi/sfi_acpi.c:135:32: error: dereferencing pointer to incomplete type
drivers/sfi/sfi_acpi.c: In function 'sfi_acpi_table_show':
drivers/sfi/sfi_acpi.c:195:12: error: dereferencing pointer to incomplete type
drivers/sfi/sfi_acpi.c: In function 'sfi_acpi_sysfs_init':
drivers/sfi/sfi_acpi.c:207:12: error: dereferencing pointer to incomplete type
drivers/sfi/sfi_acpi.c:207:12: error: invalid application of 'sizeof' to incomplete type 'struct acpi_table_header'
drivers/sfi/sfi_acpi.c:210:35: error: dereferencing pointer to incomplete type
make[3]: *** [drivers/sfi/sfi_acpi.o] Error 1



-- 
~Randy
