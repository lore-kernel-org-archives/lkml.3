Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaKQSu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:50:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaKQSu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:50:26 -0500
Date: Mon, 17 Nov 2014 10:50:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/3] kernel: add sysfs documentation for live patching
Message-ID: <20141117185024.GB13995@kroah.com>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com>
 <1416187764-3341-4-git-send-email-sjenning@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416187764-3341-4-git-send-email-sjenning@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 07:29:24PM -0600, Seth Jennings wrote:
> Adds sysfs interface documentation to Documentation/ABI/testing/
> 
> Signed-off-by: Seth Jennings <sjenning@redhat.com>
> ---
>  Documentation/ABI/testing/sysfs-kernel-livepatch | 44 ++++++++++++++++++++++++
>  MAINTAINERS                                      |  1 +
>  2 files changed, 45 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-kernel-livepatch

Looks good, thanks for adding the documentation.

greg k-h
