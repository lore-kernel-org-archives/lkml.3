Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3J3Uhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:37:38 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:63513 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3J3Uhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:37:37 -0400
Message-ID: <52716E2D.8060708@gmail.com>
Date: Thu, 31 Oct 2013 07:38:05 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Frank Haverkamp <haver@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        utz.bacher@de.ibm.com, mmarek@suse.cz, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com> <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com> <20131030173521.GB20147@kroah.com>
In-Reply-To: <20131030173521.GB20147@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/13 04:35, Greg KH wrote:

> On Wed, Oct 30, 2013 at 10:32:58AM +0100, Frank Haverkamp wrote:
>> +if GENWQE
>> +
>> +config GENWQE_DEVNAME
>> +        string "Name for sysfs and device nodes"
>> +	default "genwqe"
>> +        help
>> +          Select alternate name for sysfs and device nodes.
> 
> Don't let the user pick this, it's up to the driver to set this once and
> then live with it.
> 
> And, from what I can tell in the driver, this help text is wrong (there
> are no device nodes with this name in it, right?)


The indentation is also messed up here. Kconfig should use hard tabs, with
two additional spaces for the help text. This has mixed tabs and spaces
between lines.

~Ryan


