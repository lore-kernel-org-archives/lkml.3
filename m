Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3GTJn4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 05:43:56 -0400
Received: from mout.gmx.net ([212.227.17.20]:64587 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab3GTJnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 05:43:55 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Sherry Hurwitz <sherry.hurwitz@amd.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-firmware/AMD: add readme files for amd-ucode
Date: Sat, 20 Jul 2013 11:43:44 +0200
Message-ID: <1581606.2MIpuxPjZY@ax5200p>
User-Agent: KMail/4.8.5 (Linux/3.5.0-27-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1374273832-5228-1-git-send-email-sherry.hurwitz@amd.com>
References: <1374273832-5228-1-git-send-email-sherry.hurwitz@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:43s06L+w6/MWQuDQUidsPoGN6/kB0uIcGNhtJk9Fsn4XdTu2Gvr
 bjiQCI5Jg1WCkljhe2dvlQKfwKBGUIH3KIIfV2imsVxUgSngP/JLzggsY/LJbn0v9MnEpMH
 +b5UfRC99uoS0k71HXFiKkAIWOZGYWfE/yZ4xJ8FjQbo4s8IePqw2d1QE+jyQ2JjkN4HBlP
 wZ0hWn2NKLET1FZ8vIjFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 July 2013 17:43:52 Sherry Hurwitz wrote:
> File: README
> File: microcode_amd.bin.README
> File: microcode_amd_fam15h.bin.README
> 
> Signed-off-by: Sherry Hurwitz <sherry.hurwitz@amd.com>
> ---
>  amd-ucode/README                          |   46
> +++++++++++++++++++++++++++++ amd-ucode/microcode_amd.bin.README        |  
> 29 ++++++++++++++++++ amd-ucode/microcode_amd_fam15h.bin.README |   13
> ++++++++
>  3 files changed, 88 insertions(+)
>  create mode 100644 amd-ucode/README
>  create mode 100644 amd-ucode/microcode_amd.bin.README
>  create mode 100644 amd-ucode/microcode_amd_fam15h.bin.README
> 
> diff --git a/amd-ucode/README b/amd-ucode/README
> new file mode 100644
> index 0000000..a92831d
> --- /dev/null
> +++ b/amd-ucode/README
> @@ -0,0 +1,46 @@
> +This package provides latest microcode patches
> +for AMD processor families >= 0x10.
> +
> +See http://www.amd64.org/support/microcode.html
> +for details.

Wasn't this URL deprecated (at least it's offline now)?

Marc

