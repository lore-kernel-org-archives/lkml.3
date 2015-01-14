Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbbANVQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:16:17 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:32894 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbbANVQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:16:16 -0500
Date: Thu, 15 Jan 2015 00:16:13 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Calvin Owens <calvinowens@fb.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Message-ID: <20150114211613.GH2253@moon>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
 <20150114152501.GB9820@node.dhcp.inet.fi>
 <20150114153323.GF2253@moon>
 <20150114204653.GA26698@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114204653.GA26698@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 12:46:53PM -0800, Calvin Owens wrote:
> > > 
> > > Restriction to CAP_SYSADMIN for follow_link is undertansble, but why do we
> > > restrict readdir and readlink?
> > 
> > We didn't think this functionality might be needed someone but us (criu camp),
> > so that the rule of thumb was CONFIG_CHECKPOINT_RESTORE + CAP_SYSADMIN, until
> > otherwise strictly needed. So I think now we can relax security rules a bit
> > and allow to readdir and such for owners.
> 
> Ah, I feel silly for missing that. I'll send a patch to move map_files
> out from behind CONFIG_CHECKPOINT_RESTORE and change the permissions.

Sure
