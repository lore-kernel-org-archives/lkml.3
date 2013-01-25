Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab3AYFpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 00:45:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab3AYFpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 00:45:52 -0500
Date: Fri, 25 Jan 2013 00:45:44 -0500
From: Kyle McMartin <kmcmarti@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        jstancek@redhat.com, Stephan Mueller <stephan.mueller@atsec.com>
Subject: Re: [PATCH] MODSIGN: flag modules that use cryptoapi and only panic
 if those are unsigned
Message-ID: <20130125054544.GM6538@redacted.bos.redhat.com>
References: <20130122184357.GD6538@redacted.bos.redhat.com>
 <8615.1358940375@warthog.procyon.org.uk>
 <50FFFF48.6020608@atsec.com>
 <20130124190610.GI6538@redacted.bos.redhat.com>
 <874ni6qhlq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874ni6qhlq.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:06:01AM +1030, Rusty Russell wrote:
> Kyle McMartin <kyle@redhat.com> writes:
> > After thinking about it a while, this seems like the best way to solve
> > the problem, although it does still kind of offend my delicate
> > sensibilities...
> 
> You're far too polite.  This patch was horrible, partial and ugly.
> 

Yeah, fair enough.
