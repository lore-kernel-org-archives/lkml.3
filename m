Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935844Ab3DKPHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:07:47 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38386 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab3DKPHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:07:46 -0400
Message-ID: <5166D1BB.3070101@mev.co.uk>
Date: Thu, 11 Apr 2013 16:07:39 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130410 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Schleef <ds@schleef.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 05/26] comedi: Don't use create_proc_read_entry() [RFC]
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk> <20130411132819.32763.72806.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132819.32763.72806.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-04-11 14:28, David Howells wrote:
> Don't use create_proc_read_entry() as that is deprecated, but rather use
> proc_create_data() and seq_file instead.

It seems to work okay and is simpler than I thought it would be!  You 
changed the mode of the file to 0644 for some reason though.  Please 
change it back to 0444 or S_IFREG | S_IRUGO.  Thanks.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
