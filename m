Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3DLK6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 06:58:39 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:56800 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3DLK6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 06:58:37 -0400
Date: Fri, 12 Apr 2013 12:58:35 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: David Howells <dhowells@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 24/26] cris: Don't use create_proc_read_entry() [RFC]
Message-ID: <20130412105835.GU25525@axis.com>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
 <20130411133047.32763.25315.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411133047.32763.25315.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 03:30:47PM +0200, David Howells wrote:
> Don't use create_proc_read_entry() as that is deprecated, but rather use
> proc_create_data() and seq_file instead.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Mikael Starvik <starvik@axis.com>

Looks good,

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
