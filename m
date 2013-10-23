Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3JWJcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:32:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab3JWJcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:32:39 -0400
Date: Wed, 23 Oct 2013 10:32:34 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [ 109/171 ] userns: Dont allow creation if the user is chrooted
Message-ID: <20131023093234.GA5968@hercules>
References: <20130411202503.783159048@goodmis.org>
 <20130411202604.189219756@goodmis.org>
 <20131022111535.GC4263@hercules>
 <87wql5yzau.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wql5yzau.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 10:45:45AM -0700, Eric W. Biederman wrote:
> Luis Henriques <luis.henriques@canonical.com> writes:
> 
> > On Thu, Apr 11, 2013 at 04:26:52PM -0400, Steven Rostedt wrote:
> >> 3.6.11.2 stable review patch.
> >> If anyone has any objections, please let me know.
> >> 
> >> ------------------
> >> 
> >> From: "Eric W. Biederman" <ebiederm@xmission.com>
> >> 
> >> [ Upstream commit 3151527ee007b73a0ebd296010f1c0454a919c7d ]
> >
> > While looking at some security bugs, I came across this one
> > (CVE-2013-1956).  All the references I could find refer to the 3.8
> > kernel only, and this was the only backport I could find to older
> > stable kernels.
> >
> > Could someone clarify if this fix should be included in other stable
> > kernels?  Or the only affected kernels were the 3.8.0 to 3.8.5?
> 
> Strictly speaking there are older kernels affected.  I think it was 3.5
> that had my earliest user namespace bits, and this bug came in with the
> first of those bits.  However prior to 3.8 simply not enough things were
> converted for most people to build a kernel with user namespaces
> enabled.  I don't think distro's will have user namespaces enabled prior
> to 3.12 as that is when xfs the last hold out was finally converted.
> 
> Eric

That makes perfect sense to me.  Thanks a lot for the clarification,
Eric.

Cheers,
--
Luis
