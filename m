Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3JUIRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:17:04 -0400
Received: from oproxy13-pub.mail.unifiedlayer.com ([69.89.16.30]:51544 "HELO
	oproxy13-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752633Ab3JUIRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:17:02 -0400
Message-ID: <1382343407.2349.3.camel@slavad-ubuntu>
Subject: Re: [PATCH] hfs: remove duplicate includes
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Reply-To: slava@dubeyko.com
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 21 Oct 2013 12:16:47 +0400
In-Reply-To: <1382342497-3132-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382342497-3132-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 109.188.124.63 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-21 at 10:01 +0200, Michael Opdenacker wrote:
> This patch removes duplicate includes from fs/hfs/btree.h
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  fs/hfs/btree.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/hfs/btree.h b/fs/hfs/btree.h
> index 2a1d712..f6bd266 100644
> --- a/fs/hfs/btree.h
> +++ b/fs/hfs/btree.h
> @@ -153,11 +153,6 @@ struct hfs_btree_header_rec {
>  	u32 reserved3[16];
>  } __packed;
>  
> -#define HFS_NODE_INDEX	0x00	/* An internal (index) node */
> -#define HFS_NODE_HEADER	0x01	/* The tree header node (node 0) */
> -#define HFS_NODE_MAP		0x02	/* Holds part of the bitmap of used nodes */
> -#define HFS_NODE_LEAF		0xFF	/* A leaf (ndNHeight==1) node */
> -

Yes, it is really duplicate declarations.

Thank you for cleanup.

Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Vyacheslav Dubeyko.

>  #define BTREE_ATTR_BADCLOSE	0x00000001	/* b-tree not closed properly. not
>  						   used by hfsplus. */
>  #define HFS_TREE_BIGKEYS	0x00000002	/* key length is u16 instead of u8.


