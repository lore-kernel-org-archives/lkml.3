Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3GHTAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:00:44 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47445 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3GHTAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:00:42 -0400
MIME-Version: 1.0
In-Reply-To: <51D445D2.50906@linux.vnet.ibm.com>
References: <20130701230800.GO23515@pd.tnic>
	<20130702112424.6401.11586.stgit@localhost.localdomain>
	<20130703144447.GB13951@pd.tnic>
	<51D445D2.50906@linux.vnet.ibm.com>
Date: Mon, 8 Jul 2013 12:00:41 -0700
Message-ID: <CA+8MBbKU-YHrVvV6uxE2gJ8Ko=06o=_y90peUBsC4SvOXMLO_w@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mce, acpi/apei: Soft-offline a page on firmware
 GHES notification
From: Tony Luck <tony.luck@gmail.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 8:40 AM, Naveen N. Rao
<naveen.n.rao@linux.vnet.ibm.com> wrote:

>>> +#ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
>>> +       int sec_sev = ghes_severity(gdata->error_severity);
>>> +       struct cper_sec_mem_err *mem_err;
>>> +       mem_err = (struct cper_sec_mem_err *)(gdata+1);
>>
>>
>> A newline here please. Also, spaces around '+'.

I was off on vacation last week - looks like you got lots done without me :-)

I have parts 1 & 2 applied to an internal tree. Looks like parts 3 & 4 need a
few final polishes to get an Ack from Boris.

-Tony
