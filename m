Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbaJaVyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:54:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54567 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759729AbaJaVyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:54:31 -0400
Date: Fri, 31 Oct 2014 21:54:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ovl: initialize ->is_cursor
Message-ID: <20141031215429.GN7996@ZenIV.linux.org.uk>
References: <20141031190242.GA19099@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031190242.GA19099@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 08:02:42PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> This goes on top of "ovl: fix check for cursor".

Applied
