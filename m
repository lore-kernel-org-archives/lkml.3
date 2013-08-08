Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966062Ab3HHRrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:47:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966002Ab3HHRrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:47:11 -0400
Date: Thu, 8 Aug 2013 10:46:57 -0700
From: Zach Brown <zab@redhat.com>
To: dsterba@suse.cz, Arne Jansen <sensille@gmx.net>,
        Sergei Trofimovich <slyich@gmail.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 6/7] btrfs: cleanup: removed unused 'btrfs_reada_detach'
Message-ID: <20130808174657.GV12314@lenny.home.zabbo.net>
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
 <1375911803-17318-7-git-send-email-slyich@gmail.com>
 <520349BA.8080006@gmx.net>
 <20130808132614.GS5284@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808132614.GS5284@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > even though the function is currently unused, I'm hesitating to remove it
> > as it's part of the reada-API and might be handy for anyone going to use
> > the API in the future.
> 
> I agree. As replied here,
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24047.html
> please keep the function.

If we're keeping score, put me down for being in favour of removing dead
untested code.  git ressurection is easy. 

- z
