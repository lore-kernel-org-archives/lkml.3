Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab3JaAEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 20:04:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40171 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab3JaAEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 20:04:12 -0400
Message-ID: <52719E25.7000505@zytor.com>
Date: Wed, 30 Oct 2013 17:02:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joseph Salisbury <joseph.salisbury@canonical.com>,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC: JBottomley@Parallels.com, LKML <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal.mostafa@canonical.com>,
        linux-scsi@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>
Subject: Re: Subject:  [v3.8][v3.11][Regression] [SCSI] sd: Update WRITE SAME
 heuristics
References: <52700AD2.6000703@canonical.com> <5270108E.5040401@itwm.fraunhofer.de> <52715DF5.9040100@canonical.com>
In-Reply-To: <52715DF5.9040100@canonical.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 12:28 PM, Joseph Salisbury wrote:
> Hi Bernd,
> 
> The bug reporter confirms that your patch fixes the bug.  Any chance
> this patch can make it into 3.12?

FWIW, I don't think reverting the WRITE SAME patch is an option -- it
causes serious filesystem failures.

	-hpa

