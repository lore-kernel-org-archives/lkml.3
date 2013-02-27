Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab3B0Jjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 04:39:45 -0500
Received: from plane.gmane.org ([80.91.229.3]:37700 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab3B0Jjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 04:39:44 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: ownssh <ownssh@gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Date: Wed, 27 Feb 2013 09:35:24 +0000 (UTC)
Message-ID: <loom.20130227T103444-514@post.gmane.org>
References: <87ppzo79in.fsf@mid.deneb.enyo.de> <30665.1361461678@warthog.procyon.org.uk> <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com> <20130221164244.GA19625@srcf.ucam.org> <18738.1361836265@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 80.79.116.141 (Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130220 Firefox/17.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells <at> redhat.com> writes:

> 
> 
> Florian Weimer <fw <at> deneb.enyo.de> wrote:
> 
> > Seriously, folks, can we go back one step and discuss what problem you
> > are trying to solve?  Is it about allowing third-party kernel modules
> > in an environment which does not allow unsigned ring 0 code execution?
> 
> Let me try and lay things out:
> 
>  (1) Like it or not, the reality is that machines exist that have UEFI secure

I think, redhat should have their own root key to sign binary files.
Bootloader of install media can be sign by MS certificates, but only use to add
the redhat root key to UEFI database before install.
It will solve many problems like MS blacklist the keys although redhat said MS
wont do that forever.

And, even you do the all things of A-G, it still wont safe because many
vulnerabilities can let the attacker enter ring0 only use to exploit the exist
signed kernel module or kernel itself.

