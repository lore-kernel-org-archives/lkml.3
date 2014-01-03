Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaACWkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 17:40:41 -0500
Received: from atl.turmel.org ([74.117.157.138]:46227 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbaACWkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:40:40 -0500
X-Greylist: delayed 934 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jan 2014 17:40:40 EST
Message-ID: <52C738C0.5090604@turmel.org>
Date: Fri, 03 Jan 2014 17:25:04 -0500
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>,
        Eric Appleman <erappleman@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: GPL violators (charging for a Linux kernel by itself and then
 charging again for source)
References: <loom.20140103T194726-983@post.gmane.org> <CAFLxGvzVw31Z=hLi35J5_zE4PA5RDMgyQmcNd0kgk9LXr-kQAg@mail.gmail.com>
In-Reply-To: <CAFLxGvzVw31Z=hLi35J5_zE4PA5RDMgyQmcNd0kgk9LXr-kQAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 05:07 PM, Richard Weinberger wrote:
> On Fri, Jan 3, 2014 at 7:56 PM, Eric Appleman <erappleman@gmail.com> wrote:

>> Wasn't the whole idea of a fee being permitted an acknowledgment that
>> physical distribution of source was acceptable if electronic was not
>> possible (low bandwidth ISP, security concerns, etc).
> 
> GPLv2 states:
> "You may charge a fee for the physical act of transferring a copy, and
> you may at your option offer warranty protection in exchange for a
> fee."

Yeah, that's section #1.  Charge all you want for general distribution.

But you are forgetting section #3, which kicks in if you distribute in
compiled or executable form.  It limits the fee for separate source code
delivery to "no more than your cost of physically performing source
distribution"

Only your customers are entitled to that service, though.

But IANAL.

Regards,

Phil
