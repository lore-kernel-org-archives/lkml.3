Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab3AYBB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:01:26 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:49679 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab3AYBBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:01:19 -0500
Date: Thu, 24 Jan 2013 17:01:12 -0800
From: Tejun Heo <tj@kernel.org>
To: James Hogan <james@albanarts.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] async: replace list of active domains with global
 list of pending items
Message-ID: <20130125010112.GF2373@mtj.dyndns.org>
References: <20130119003923.GH24579@htj.dyndns.org>
 <20130119004100.GL24579@htj.dyndns.org>
 <20130125001345.GA1960@balrog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125001345.GA1960@balrog>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 25, 2013 at 12:13:45AM +0000, James Hogan wrote:
> Should it have this?
> +	else
> +		INIT_LIST_HEAD(&entry->global_list)

I think it would be better to have INIT_LIST_HEAD() during @entry
initialization.  Heh, I forgot that.  I wonder why it didn't crash on
my machine.  Can you please cook up a patch to init both list fields
right after kzalloc()?

Thanks.

-- 
tejun
