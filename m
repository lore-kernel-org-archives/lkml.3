Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaFZRCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:02:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbaFZRCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:02:06 -0400
Date: Thu, 26 Jun 2014 19:02:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs compression: reuse recently used workspace
Message-ID: <20140626170205.GA1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1403622044-2964-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1403622044-2964-2-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403622044-2964-2-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 12:00:44AM +0900, Sergey Senozhatsky wrote:
> Add compression `workspace' in free_workspace() to
> `idle_workspace' list head, instead of tail. So we have
> better chances to reuse most recently used `workspace'.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Makes sense to me,
Reviewed-by: David Sterba <dsterba@suse.cz>
