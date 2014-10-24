Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaJXCzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:55:49 -0400
Received: from tundra.namei.org ([65.99.196.166]:50455 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaJXCzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:55:48 -0400
Date: Fri, 24 Oct 2014 13:55:27 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
cc: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        jack@suse.cz, dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 1/2] ima: check xattr value length in
 ima_inode_setxattr()
In-Reply-To: <5b1f234e8515c10c96a16868ff4341f29460f38f.1414071910.git.d.kasatkin@samsung.com>
Message-ID: <alpine.LRH.2.11.1410241355020.30398@namei.org>
References: <cover.1414071910.git.d.kasatkin@samsung.com> <5b1f234e8515c10c96a16868ff4341f29460f38f.1414071910.git.d.kasatkin@samsung.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014, Dmitry Kasatkin wrote:

> ima_inode_setxattr() can be called with no value. Function does not
> check the length so that following command can be used to produce
> kernel oops: setfattr -n security.ima FOO. This patch fixes it.

I'd like to see more review/acks on this before sending it to Linus.

Mimi?


-- 
James Morris
<jmorris@namei.org>

