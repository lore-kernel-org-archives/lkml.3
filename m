Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbaIWRCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:02:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbaIWRCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:02:33 -0400
Message-ID: <5421A79F.9010003@redhat.com>
Date: Tue, 23 Sep 2014 10:02:23 -0700
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCHv3 0/8] target: Save memory on unused se_dev_entrys and
 se_luns
References: <1404171587-28845-1-git-send-email-agrover@redhat.com>	 <20140729131511.GA30232@lst.de> <20140913195557.GA32118@lst.de>	 <1411025936.13381.183.camel@haakon3.risingtidesystems.com>	 <541B629B.6090406@redhat.com> <1411082258.28382.17.camel@haakon3.risingtidesystems.com>
In-Reply-To: <1411082258.28382.17.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 04:17 PM, Nicholas A. Bellinger wrote:

> I'm currently reviewing #2, #4, #5 and #7 and will consider merging
> these.  These cleanups account for most of the LOC reduction, and avoid
> most of the larger concerns.
>
> Also for patches like this, they really need testing on your end before
> I'll consider them merging.  Compile testing alone for these types of
> locking changes is not enough, given the history of regressions with
> these types of cleanups.

OK. I'll look for those to show up in your tree, then? And work on 
better dividing up of the remaining changes, and also minimize their 
risk of causing regressions.

Regards -- Andy

