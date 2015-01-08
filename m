Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbbAHB1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:27:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbbAHB1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:27:31 -0500
Date: Wed, 7 Jan 2015 17:27:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3.18 04/84] x86_64, switch_to(): Load TLS descriptors
 before switching DS and ES
Message-ID: <20150108012730.GB23167@kroah.com>
References: <20150107014029.012974975@linuxfoundation.org>
 <20150107014029.158919470@linuxfoundation.org>
 <54AD502D.7070107@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AD502D.7070107@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 04:26:37PM +0100, Jiri Slaby wrote:
> On 01/07/2015, 02:49 AM, Greg Kroah-Hartman wrote:
> > 3.18-stable review patch.  If anyone has any objections, please let me know.
> 
> Greg, Andi raised an objection against this one for 3.12 which still
> holds here and for other trees:
> https://www.mail-archive.com/stable@vger.kernel.org/msg106471.html
> 
> Quoting:
> On 01/06/2015, 07:53 PM, Andi Kleen wrote:
> > IMHO this is not stable material. Significant risk you broke
> > something obscure, and it's not clear it fixes any real problem.
> >
> > At least wait some more time first.
> 
> Thanks.

I've now responded to that thread, thanks.

greg k-h
