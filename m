Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab3B0UgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 15:36:04 -0500
Received: from plane.gmane.org ([80.91.229.3]:33103 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab3B0UgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:36:02 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: ownssh <ownssh@gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Date: Wed, 27 Feb 2013 20:35:45 +0000 (UTC)
Message-ID: <loom.20130227T210924-53@post.gmane.org>
References: <87ppzo79in.fsf@mid.deneb.enyo.de> <30665.1361461678@warthog.procyon.org.uk> <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com> <20130221164244.GA19625@srcf.ucam.org> <18738.1361836265@warthog.procyon.org.uk> <loom.20130227T103444-514@post.gmane.org> <20130227145647.GA5184@srcf.ucam.org>
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

Matthew Garrett <mjg59 <at> srcf.ucam.org> writes:

> There's no way to update the UEFI key database without the update being 
> signed by an already trusted key, so what you're proposing isn't 
> possible.
> 

I confused.
Isn't custom mode can add user's own key?
> http://mjg59.dreamwidth.org/12368.html
> But I don't trust Microsoft
So I dont trust, I very worry MS will block the key they give in some day then
most fedora user need disable secure boot & update kernel and kmod signed
by that key.

I think secure boot should not control by MS, but if it's,
then it should not merge to linux kernel.

