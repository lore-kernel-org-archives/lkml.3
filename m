Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbaJUWTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:19:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933394AbaJUWTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:19:53 -0400
Message-ID: <1413929992.30946.59.camel@localhost>
Subject: Re: [PATCH V5 0/5] audit by executable name
From: Eric Paris <eparis@redhat.com>
To: Paul Moore <pmoore@redhat.com>
Cc: Steve Grubb <sgrubb@redhat.com>, Richard Guy Briggs <rgb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org, aviro@redhat.com
Date: Tue, 21 Oct 2014 18:19:52 -0400
In-Reply-To: <3623738.X9Kq6ePK5C@sifl>
References: <cover.1412303728.git.rgb@redhat.com> <2652562.S2IH3gqS0u@sifl>
	 <4185398.VpQETdPFDe@x2> <3623738.X9Kq6ePK5C@sifl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 17:56 -0400, Paul Moore wrote:

> * Change the audit_status.version field comment in include/uapi/linux/audit.h 
> to "/* audit functionality bitmap */", or similar.  We can't really change the 
> structure now, but the comment is fair game.

Trying to think how to do things with a #define so you can rename,
"version" is pretty darn generic to pre-process.  You could make it a
union, so userspace code and use a sane name....

> 
> * Change AUDIT_VERSION_LATEST to a bitmask instead of a number.  For example, 
> it should be 3 given the current code, not 2.  In a perfect world this 
> wouldn't even be in the uapi header, but it is so we need to keep it updated.  
> Bumping it higher should be backwards compatible.

Getting 1 without 2 is actually hard to accompish as I remember, but
yes, you're right, i missed that.  I should be 3....

> Can anyone think of anything else that might be affected by this?

No one uses this stuff, just change it.


