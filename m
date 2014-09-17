Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaIQDFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 23:05:04 -0400
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:43489 "EHLO
	homiemail-a59.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877AbaIQDFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 23:05:02 -0400
Date: Tue, 16 Sep 2014 23:05:00 -0400
From: Shea Levy <shea@shealevy.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Setting FS_USERNS_MOUNT in btrfs_fs_type.fs_flags
Message-ID: <20140917030500.GD6185@nixos.hsd1.nh.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

What work would be required to mark btrfs_fs_type with FS_USERNS_MOUNT
so that btrfs images can be mounted by unprivileged users within a user
namespace (along with something like [1])? I'd like to be able to create
disk images without having to start a VM (and --rootdir isn't flexible
enough because I want to make subvolumes).

Cheers,
Shea Levy

P.S. I am not subscribed to either list, please CC me in replies

[1] https://lkml.org/lkml/2014/5/27/690
