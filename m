Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3KKNr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:47:59 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38666 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3KKNru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:47:50 -0500
Date: Mon, 11 Nov 2013 07:47:45 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Rob Landley <rob@landley.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trace-cmd 4/5] Documentation: Add kernelshark.1.txt
Message-ID: <20131111134745.GA9953@thinkpad-t410>
Mail-Followup-To: Rob Landley <rob@landley.net>,
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
 <1382642074-15567-5-git-send-email-seth.forshee@canonical.com>
 <1384152893.1974.264@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384152893.1974.264@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 12:54:53AM -0600, Rob Landley wrote:
> On 10/24/2013 02:14:33 PM, Seth Forshee wrote:
> >Add a man page for kernelshark.
> >
> >Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> >---
> > Documentation/kernelshark.1.txt | 46
> >+++++++++++++++++++++++++++++++++++++++++
> > 1 file changed, 46 insertions(+)
> > create mode 100644 Documentation/kernelshark.1.txt
> >
> >diff --git a/Documentation/kernelshark.1.txt
> >b/Documentation/kernelshark.1.txt
> >new file mode 100644
> >index 0000000..6a217dd
> >--- /dev/null
> >+++ b/Documentation/kernelshark.1.txt
> >@@ -0,0 +1,46 @@
> >+KERNELSHARK(1)
> >+==============
> >+
> >+NAME
> >+----
> >+kernelshark - graphical reader for trace-cmd(1) output
> >+
> 
> We're throwing random man pages into Documentation now, at the top
> level with no subdirectory?
> 
> Please don't.

You do realize this patch is for trace-cmd and not for the kernel,
right?

Seth
