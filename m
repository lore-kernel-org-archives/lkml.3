Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaHFTxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:53:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48795 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbaHFTxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:53:14 -0400
Date: Wed, 6 Aug 2014 20:53:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
        ebiederm@xmission.com, ian.molton@codethink.co.uk
Subject: Re: [PATCH] seq_file: Allow private data to be supplied on seq_open
Message-ID: <20140806195312.GS18016@ZenIV.linux.org.uk>
References: <1406655593-12626-1-git-send-email-rob.jones@codethink.co.uk>
 <20140806160259.GR18016@ZenIV.linux.org.uk>
 <53E254F1.30605@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E254F1.30605@codethink.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 05:16:49PM +0100, Rob Jones wrote:

> I'm not quite sure I understand your meaning when you say "via seq_open"
> though, that function call format needs to stay the same or lots of
> code will break, so I can't just add the third parameter on the end.
> (C++ does have *some* advantages!) Can you clarify, please?

seq_open_private() can be implemented as call of seq_open() + assignment...
