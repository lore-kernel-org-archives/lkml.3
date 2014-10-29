Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934623AbaJ2Q3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:29:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459AbaJ2Q3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:29:36 -0400
Date: Wed, 29 Oct 2014 12:29:27 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, sgrubb@redhat.com, pmoore@redhat.com
Subject: Re: [PATCH][STABLE] audit: correct AUDIT_GET_FEATURE return message
 type
Message-ID: <20141029162927.GG20866@madcap2.tricolour.ca>
References: <20141029133506.GN26201@madcap2.tricolour.ca>
 <20141029155055.GC17232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029155055.GC17232@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/29, Greg KH wrote:
> On Wed, Oct 29, 2014 at 09:35:06AM -0400, Richard Guy Briggs wrote:
> > When an AUDIT_GET_FEATURE message is sent from userspace to the kernel, it
> > should reply with a message tagged as an AUDIT_GET_FEATURE type with a struct
> > audit_feature.  The current reply is a message tagged as an AUDIT_GET
> > type with a struct audit_feature.
> > 
> > This appears to have been a cut-and-paste-eo in commit b0fed40.
> > 
> > Reported-by: Steve Grubb <sgrubb@redhat.com>
> > Cc: stable@vger.kernel.org # v3.13-rc1
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/audit.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Why did you send this directly to stable@vger?  That's not how to get a
> patch into the stable kernel trees...

Sorry, you're right.  It should be accepted upstream first.  I'll go
back and make sure that gets done...

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
