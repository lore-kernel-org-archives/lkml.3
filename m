Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaKGDbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 22:31:19 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35846 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaKGDbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 22:31:16 -0500
X-Originating-IP: 50.43.41.112
Date: Thu, 6 Nov 2014 19:31:02 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
        Changli Gao <xiaosuo@gmail.com>, David Rientjes <rientjes@google.com>,
        Eric Paris <eparis@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Jesse Gross <jesse@nicira.com>, Jonathan Corbet <corbet@lwn.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pravin Shelar <pshelar@nicira.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] lib/flex_array: make build optional
Message-ID: <20141107033102.GB7249@thin>
References: <1415309241-12971-1-git-send-email-aris@redhat.com>
 <545BE927.9060208@sr71.net>
 <545BEBD6.4030803@sr71.net>
 <20141106215056.GK26472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106215056.GK26472@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 04:50:56PM -0500, Aristeu Rozanski wrote:
> On Thu, Nov 06, 2014 at 01:44:54PM -0800, Dave Hansen wrote:
> > On 11/06/2014 01:33 PM, Dave Hansen wrote:
> > > On 11/06/2014 01:27 PM, Aristeu Rozanski wrote:
> > >> +config FLEX_ARRAY
> > >> +	bool "Flexible array"
> > >> +	default n
> > >> +	help
> > >> +	  This option enables an implementation of flexible arrays which
> > >> +	  allows creating arrays of fixed size elements with an arbritrary
> > >> +	  size without requiring the single allocation of a contiguous area.
> > >> +
> > >> +	  See Documentation/flexible-arrays.txt
> > > 
> > > Is there any reason to expose this to the user via Kconfig?
> > > 
> > > No sane person would even turn it on if they don't need it.
> > 
> > IOW, I think you should just make it:
> > 
> > config FLEX_ARRAY
> > 	def_bool n
> 
> Joe Pershes complained on a similar patch on making it default to 'n'.
> Will rework the patches this way.

https://git.kernel.org/cgit/linux/kernel/git/josh/linux.git/commit/?h=tiny/unflex-array&id=6631d5fb4cf395ebd2dc0f2da05525b9d3436a3f

Already done.

- Josh Triplett
