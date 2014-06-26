Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbaFZIFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:05:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbaFZIFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:05:05 -0400
Message-ID: <53ABD429.9090306@redhat.com>
Date: Thu, 26 Jun 2014 10:04:57 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Eddie Wai <eddie.wai@broadcom.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: bnx2i: bnx2i_iscsi.c: Cleaning up variable is set
 more than once
References: <1403705059-25834-1-git-send-email-rickard_strandqvist@spectrumdigital.se>	<53AADC16.9080301@redhat.com>	<1403716401.10214.2.camel@lbirv-waie-lx2.broadcom.com> <CAFo99gbp-CeoT-3rNkNJX1m79G+5zi7pJLjX9kYq=FEf1isn=g@mail.gmail.com>
In-Reply-To: <CAFo99gbp-CeoT-3rNkNJX1m79G+5zi7pJLjX9kYq=FEf1isn=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/26/2014 02:28 AM, Rickard Strandqvist wrote:
> 
> If it's not obvious, I do all my fixes without changing the previous
> intent. But obviously it is not always right, rather it is one of main
> reasons to fix this type of error :)

Yes it is obvious, your patch was correct (it didn't modify the function behaviour)
but helped to spot a defect.

> 
> But I'll make a new patch then, with = 3 ?

Yes, please submit a new patch which sets custom_length = 3 at the end of the function.

Thanks,
Maurizio Lombardi
