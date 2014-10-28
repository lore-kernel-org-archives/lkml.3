Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaJ1KzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:55:19 -0400
Received: from mta-out1.inet.fi ([62.71.2.194]:48421 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbaJ1KzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:55:15 -0400
Date: Tue, 28 Oct 2014 12:54:58 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        lttng-dev <lttng-dev@lists.lttng.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Progress on system crash traces with LTTng using DAX and pmem
Message-ID: <20141028105458.GA9768@node.dhcp.inet.fi>
References: <1254279794.1957.1414240389301.JavaMail.zimbra@efficios.com>
 <465653369.1985.1414241485934.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465653369.1985.1414241485934.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 12:51:25PM +0000, Mathieu Desnoyers wrote:
> FYI, the main reason why my customer wants to go with a
> "trace into memory that survives soft reboot" approach
> rather than to use things like kexec/kdump is that they
> care about the amount of time it takes to reboot their
> machines. They want a solution where they can extract the
> detailed crash data after reboot, after the machine is
> back online, rather than requiring a few minutes of offline
> time to extract the crash details.

IIRC, on x86 there's no guarantee that your memory content will be
preserved over reboot. BIOS is free to mess with it.

-- 
 Kirill A. Shutemov
