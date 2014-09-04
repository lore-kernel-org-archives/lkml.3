Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaIDROd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:14:33 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:50777 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaIDROc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <1409836833-4320-1-git-send-email-kirr@nexedi.com>
References: <1409836833-4320-1-git-send-email-kirr@nexedi.com>
Date: Thu, 4 Sep 2014 10:14:31 -0700
Message-ID: <CABQzsv_9K0WrddMW60DkUbsv2B5BwLNFCES2TNvfVNaG-ym6YA@mail.gmail.com>
Subject: Re: [PATCH] hugetlbfs: document that sticky mounts are allowed
From: Ken Chen <kenchen@google.com>
To: Kirill Smelkov <kirr@nexedi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 6:20 AM, Kirill Smelkov <kirr@nexedi.com> wrote:
> Commit 75897d60 (hugetlb: allow sticky directory mount option) added
> support for mounting hugetlbfs with sticky option set, like /tmp is
> usually mounted, but forgot to document that.
>
> Cc: Ken Chen <kenchen@google.com>
> Signed-off-by: Kirill Smelkov <kirr@nexedi.com>
> ---
>  Documentation/vm/hugetlbpage.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
> index bdd4bb9..b64e0af 100644
> --- a/Documentation/vm/hugetlbpage.txt
> +++ b/Documentation/vm/hugetlbpage.txt
> @@ -274,7 +274,7 @@ This command mounts a (pseudo) filesystem of type hugetlbfs on the directory
>  /mnt/huge.  Any files created on /mnt/huge uses huge pages.  The uid and gid
>  options sets the owner and group of the root of the file system.  By default
>  the uid and gid of the current process are taken.  The mode option sets the
> -mode of root of file system to value & 0777.  This value is given in octal.
> +mode of root of file system to value & 01777.  This value is given in octal.
>  By default the value 0755 is picked. The size option sets the maximum value of
>  memory (huge pages) allowed for that filesystem (/mnt/huge). The size is
>  rounded down to HPAGE_SIZE.  The option nr_inodes sets the maximum number of

Acked-by: Ken Chen <kenchen@google.com>
