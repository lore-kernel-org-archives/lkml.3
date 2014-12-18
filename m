Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaLRUD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 15:03:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaLRUD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 15:03:57 -0500
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: linux-next 20141216 BUG: sleeping function called from invalid context at mm/slab.c:2849
Date: Thu, 18 Dec 2014 15:03:54 -0500
Message-ID: <3969718.H7hYOeJgY9@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1418929486.5162.22.camel@localhost>
References: <2966.1418778594@turing-police.cc.vt.edu> <20141218184420.GF29998@madcap2.tricolour.ca> <1418929486.5162.22.camel@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 18, 2014 02:04:46 PM Eric Paris wrote:
> I'd suggest just sending the GFP type, not the who audit_buffer, but
> that's up to you.

That would be my preference too, especially since we will want to send this to 
stable and smaller is generally better there.

-- 
paul moore
security and virtualization @ redhat

