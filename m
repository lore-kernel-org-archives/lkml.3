Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab3CVBYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:24:53 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:38347 "EHLO
	homiemail-a56.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932843Ab3CVBYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:24:52 -0400
References: <1363277360-1947-1-git-send-email-shea@shealevy.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1363277360-1947-1-git-send-email-shea@shealevy.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <98307231-8FBF-47B6-89DB-81BE86904A8B@shealevy.com>
Cc: Shea Levy <shea@shealevy.com>
X-Mailer: iPad Mail (10A523)
From: Shea Levy <shea@shealevy.com>
Subject: Re: [PATCH 0/2] vfs: Report a mount r/o if the superblock is
Date: Thu, 21 Mar 2013 21:24:51 -0400
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any feedback on this?

On Mar 14, 2013, at 12:09 PM, Shea Levy <shea@shealevy.com> wrote:

> By calling mount(2) with MS_REMOUNT | MS_BIND on a non-bind readonly
> mountpoint, it is possible to have a readonly mount without MNT_READONLY
> in its mnt_flags. Currently, /proc/<pid>/mountinfo and statfs will
> report such a mount as r/w, even though for all intents and purposes it
> is still readonly.
> 
> This patchset fixes show_mountinfo and statfs to report such mounts as
> readonly.
> 
> Signed-off-by: Shea Levy <shea@shealevy.com>
> 
