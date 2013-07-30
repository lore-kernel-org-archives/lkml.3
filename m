Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab3G3Ba2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:30:28 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:61221 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3G3Ba1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:30:27 -0400
Message-ID: <51F7171C.4060100@huawei.com>
Date: Tue, 30 Jul 2013 09:30:04 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Checkpatch error on trace events macros
References: <20130729195201.GC14883@xanatos>
In-Reply-To: <20130729195201.GC14883@xanatos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/30 3:52, Sarah Sharp wrote:
> Hi Andy and Joe,
> 
> Checkpatch is complaining when code adds new trace events macros:
> 
> sarah@xanatos:~/git/kernels/xhci$ git am -s ~/Maildir.fetchmail/.to-apply
> Applying: xhci: add traces for debug messages in xhci_address_device()
> ERROR: Macros with complex values should be enclosed in parenthesis
> #86: FILE: drivers/usb/host/xhci-trace.h:15:
> +#define TRACE_SYSTEM xhci-hcd
> 
> ERROR: Macros with complex values should be enclosed in parenthesis
> #115: FILE: drivers/usb/host/xhci-trace.h:44:
> +#define TRACE_INCLUDE_PATH .
> 
> ERROR: Macros with complex values should be enclosed in parenthesis
> #118: FILE: drivers/usb/host/xhci-trace.h:47:
> +#define TRACE_INCLUDE_FILE xhci-trace
> 
> total: 3 errors, 0 warnings, 169 lines checked
> 
> 
> The macros have to be defined that way for trace events to work.

yeah, that's true, and we always just ignore chechpatch complaints
when it comes to TRACE_EVENT macros.

> Can you fix checkpatch not to complain about trace event macros?
> 

