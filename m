Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3FFG2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 02:28:55 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59836 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab3FFG2y convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 6 Jun 2013 02:28:54 -0400
Message-Id: <51B0484302000078000DBC0D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 06 Jun 2013 07:28:51 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <david.vrabel@citrix.com>, <roger.pau@citrix.com>,
        "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] xen/blkback: Check for insane amounts of request
 on the ring.
References: <1370375826-7311-1-git-send-email-konrad.wilk@oracle.com>
 <51AF7A7502000078000DB95C@nat28.tlf.novell.com>
 <20130605173541.GA12812@phenom.dumpdata.com>
In-Reply-To: <20130605173541.GA12812@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.06.13 at 19:35, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> > Looking at the code, one would expect that the existing check
>> 
>> The "expect ..." here doesn't really seem to have a proper
>> termination later in the sentence (or I'm having problems parsing
>> the whole construct), so if I didn't know what the patch is about
>> I would have a hard time following.
> 
> Oh gosh, that is very badly worded.
> 
> .. snip..
> 
> I took the advice and altered the patch and hopefully fixed
> the commit description to make more sense:

Thanks, this reads quite a bit better.

Jan

