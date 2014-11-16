Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbaKPHmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 02:42:09 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:47504 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaKPHmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 02:42:06 -0500
X-Originating-IP: 50.43.41.112
Date: Sat, 15 Nov 2014 23:41:57 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Kees Cook <keescook@chromium.org>, mtk.manpages@gmail.com,
        linux-api@vger.kernel.org, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add supplementary UIDs, and getusers/setusers system
 calls
Message-ID: <20141116074157.GA2714@thin>
References: <6b6bef0eb7328d466e8deef3d2c186a79633e0a7.1416121601.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b6bef0eb7328d466e8deef3d2c186a79633e0a7.1416121601.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 11:08:31PM -0800, Josh Triplett wrote:
>  asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist);
> +asmlinkage long sys_setusers(int uidsetsize, uid_t __user *grouplist);

Obvious typo here: s/grouplist/userlist/.  Will fix in a v2, but I'll
wait for other feedback on v1 first.

- Josh Triplett
