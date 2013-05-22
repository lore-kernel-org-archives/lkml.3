Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3EVJWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:22:53 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56039 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3EVJWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:22:43 -0400
Date: Wed, 22 May 2013 18:22:34 +0900
From: Tejun Heo <tj@kernel.org>
To: Stephan Gatzka <stephan.gatzka@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org
Subject: Re: function call fw_iso_resource_mange(..) (core-iso.c) does not
 return
Message-ID: <20130522092234.GB3466@mtj.dyndns.org>
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org>
 <20130521222817.3626b59d@stein>
 <24da2e78e684e560c5aa034cebd3e26b@gatzka.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24da2e78e684e560c5aa034cebd3e26b@gatzka.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 22, 2013 at 11:08:43AM +0200, Stephan Gatzka wrote:
> >There is quite a bit going on in firewire-ohci's and
> >firewire-core's parts
> >of self-ID-complete event handling.  But I suspect that stuff like
> >that is
> >still not in the league for which CPU_INTENSIVE was intended for
> >(cryptography etc.).
> 
> Some advice from Tejun would be great here...

No need to use CPU_INTENSIVE unless it's really burning considerable
amount of CPU cycles.  I don't know what the firewire work items are
doing but am pretty doubtful they would need the flag, and please
don't use it to work around deadlock problems. :)

Thanks.

-- 
tejun
