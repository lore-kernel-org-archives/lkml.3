Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3COPAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:00:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53664 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab3COPAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:00:37 -0400
Date: Fri, 15 Mar 2013 11:00:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Lenky Gao <lenky.gao@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Inactive memory keep growing and how to release it?
Message-ID: <20130315150022.GD7403@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Simon Jeons <simon.jeons@gmail.com>, Michal Hocko <mhocko@suse.cz>,
	Lenky Gao <lenky.gao@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"olaf@aepfle.de" <olaf@aepfle.de>,
	"apw@canonical.com" <apw@canonical.com>,
	"andi@firstfloor.org" <andi@firstfloor.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
References: <CAAO_Xo7sEH5W_9xoOjax8ynyjLCx7GBpse+EU0mF=9mEBFhrgw@mail.gmail.com>
 <20130314101403.GB11636@dhcp22.suse.cz>
 <5142DEC5.7010206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5142DEC5.7010206@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 04:41:41PM +0800, Simon Jeons wrote:
> >This is really an old kernel and also a distribution one which might
> >contain a lot of patches on top of the core kernel. I would suggest to
> >contact Redhat or try to reproduce the issue with the vanilla and
> 
> What's the meaning of vanilla?

Vanilla means an up-to-date (i.e., non-prehistoric) kernel from
kernel.org, without any "Value Added" patches from a distribution.

See: https://www.kernel.org/

Regards,

					- Ted
