Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab3KAOqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:46:35 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49295 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3KAOqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:46:34 -0400
Message-ID: <5273BEBF.2090008@cs.wisc.edu>
Date: Fri, 01 Nov 2013 09:46:23 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: open-iscsi@googlegroups.com
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: scsi-mq + open-iscsi support patches..?
References: <1382997816.19256.767.camel@haakon3.risingtidesystems.com>
In-Reply-To: <1382997816.19256.767.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 5:03 PM, Nicholas A. Bellinger wrote:
> Hi Mike,
>
> Just curious as to the status of the scsi-mq conversion patches for
> open-iscsi that you where working on a while back..?
>
> I'm asking because recently I've been spending alot of time with scsi-mq
> + virtio-scsi, and would really to start banging on iser-target ports
> using an scsi-mq enabled iser-initiator as well..
>
> So that said, are there any blockers holding things up towards getting a
> working prototype..?
>

Just time. Just finished a release at work and just got back from 
vacation so hoping to work on this some more in the next weeks.

On a related note, some iscsi vendor has been hitting a crash with your 
tree. Have you rebased it it to take in Christoph's changes and fixes 
that are in Jens's tree? The code here

https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/log/?h=scsi-mq

looks ok. That is the current code right?

