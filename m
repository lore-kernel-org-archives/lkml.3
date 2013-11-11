Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3KKGzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 01:55:03 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:43424 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3KKGy4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 01:54:56 -0500
Date: Mon, 11 Nov 2013 00:54:53 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH trace-cmd 4/5] Documentation: Add kernelshark.1.txt
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
	<1382642074-15567-5-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1382642074-15567-5-git-send-email-seth.forshee@canonical.com>
	(from seth.forshee@canonical.com on Thu Oct 24 14:14:33 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1384152893.1974.264@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 02:14:33 PM, Seth Forshee wrote:
> Add a man page for kernelshark.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  Documentation/kernelshark.1.txt | 46  
> +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/kernelshark.1.txt
> 
> diff --git a/Documentation/kernelshark.1.txt  
> b/Documentation/kernelshark.1.txt
> new file mode 100644
> index 0000000..6a217dd
> --- /dev/null
> +++ b/Documentation/kernelshark.1.txt
> @@ -0,0 +1,46 @@
> +KERNELSHARK(1)
> +==============
> +
> +NAME
> +----
> +kernelshark - graphical reader for trace-cmd(1) output
> +

We're throwing random man pages into Documentation now, at the top  
level with no subdirectory?

Please don't.

Rob