Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaFZIUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:20:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbaFZIUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:20:42 -0400
Message-ID: <53ABD7B4.5070804@redhat.com>
Date: Thu, 26 Jun 2014 10:20:04 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jack Wang <xjtuwjp@gmail.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
CC: lindar_liu@usish.com, "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: pm80xx_hwi.c:  Cleaning up variable is
 set more than once
References: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <53ABD51C.5050806@gmail.com>
In-Reply-To: <53ABD51C.5050806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 10:09 AM, Jack Wang wrote:
> Thanks Rickard,
> 
> From my point of view, looks good, but I'd like to get review from Anand
> (cc-ed).

I would like to add that I noticed that this fields is only set and appears to be never used,
maybe it could be completely removed.

Regards,
Maurizio Lombardi
