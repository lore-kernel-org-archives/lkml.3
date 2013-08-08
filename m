Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965700Ab3HHOCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:02:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965275Ab3HHOCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:02:19 -0400
Date: Thu, 8 Aug 2013 16:02:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 7/7] btrfs: cleanup: removed unused
 'btrfs_get_inode_ref_index'
Message-ID: <20130808140218.GV5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
	Sergei Trofimovich <slyich@gmail.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@fusionio.com>,
	Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
	Sergei Trofimovich <slyfox@gentoo.org>
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
 <1375911803-17318-8-git-send-email-slyich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375911803-17318-8-git-send-email-slyich@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 12:43:23AM +0300, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Found by uselex.rb:
> > btrfs_get_inode_ref_index: [R]: exported from: fs/btrfs/inode-item.o fs/btrfs/btrfs.o fs/btrfs/built-in.o
> 
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>

Safe to remove.

Reviewed-by: David Sterba <dsterba@suse.cz>
