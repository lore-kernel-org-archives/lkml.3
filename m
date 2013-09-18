Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab3IRPW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:22:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34679 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3IRPW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:22:58 -0400
Date: Wed, 18 Sep 2013 16:22:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steve French <smfrench@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, mszeredi@suse.cz,
        Steve French <sfrench@samba.org>, stable@vger.kernel.org
Subject: Re: [PATCH 05/11] cifs: fix filp leak in cifs_atomic_open()
Message-ID: <20130918152254.GN13318@ZenIV.linux.org.uk>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
 <1379335925-30858-6-git-send-email-miklos@szeredi.hu>
 <CAH2r5mt8gnJs1ji==oF6wVv2hFXjCbbZ4quRY9Xum3Fx1UA_bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mt8gnJs1ji==oF6wVv2hFXjCbbZ4quRY9Xum3Fx1UA_bw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 10:19:20AM -0500, Steve French wrote:
> Do you want me to merge this via my tree (cifs-2.6.git) or another?

It's in vfs.git#for-linus.  I'll send a pull request later today...
