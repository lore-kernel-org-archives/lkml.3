Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab3AWGAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 01:00:09 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51231 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3AWGAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 01:00:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAH2r5mtSTOWc7Caf3UA=SGY3_PoR-xFOyXHd4OiYZSGXa5W_YQ@mail.gmail.com>
References: <1358900459-26277-1-git-send-email-dinggnu@gmail.com>
	<20130122203603.1bd26363@corrin.poochiereds.net>
	<CAH2r5mtSTOWc7Caf3UA=SGY3_PoR-xFOyXHd4OiYZSGXa5W_YQ@mail.gmail.com>
Date: Wed, 23 Jan 2013 00:00:07 -0600
Message-ID: <CAH2r5mtXdqWgzhHXteEWW-5T7oPB6+Grh3fthmVpuD_64iC2tw@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/cifs_dfs_ref.c: fix potential memory leakage
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Cong Ding <dinggnu@gmail.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 11:59 PM, Steve French <smfrench@gmail.com> wrote:
> merged into cifs-2.6.git

and added cc: stable <stable@kernel.org>



-- 
Thanks,

Steve
