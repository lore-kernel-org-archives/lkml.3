Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaLNPbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 10:31:44 -0500
Received: from mout.gmx.net ([212.227.15.18]:62585 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbaLNPbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 10:31:42 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1418569030.9230.7.camel@linux.intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1418413600-5400-2-git-send-email-jarkko.sakkinen@linux.intel.com> <548D98B8.3010003@linux.vnet.ibm.com> <1418569030.9230.7.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH v10 1/8] tpm: merge duplicate transmit_cmd() functions
From: peterhuewe@gmx.de
Date: Sun, 14 Dec 2014 16:31:10 +0100
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net
Message-ID: <889c95a4-ae60-44db-be8a-fd56a9497c78@email.android.com>
X-Provags-ID: V03:K0:+9ydkS/3XRUKYi140bvNJM3AN/v3wqV4fNNLAabn5zDrSm4NtMA
 288TpZIDeSkKoZc4XgZmeWSGCDr1+DJ1QYQsFFPCvk38DRgCvXdFtu8bXzP/boKLrjmcYAF
 HNvfqq6v/rRKYUqCPvTbQJG5pCvARy5lpOyVoHStBxfnRmAplBIBDQ5tShSU9gkjI1aaiu9
 xy2i/7dWOQUM9bgQ/kBhA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14. Dezember 2014 15:57:10 MEZ, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
>On Sun, 2014-12-14 at 09:03 -0500, Stefan Berger wrote:
>> On 12/12/2014 02:46 PM, Jarkko Sakkinen wrote:
>> > Merged transmit_cmd() functions in tpm-interface.c and tpm-sysfs.c.
>> > Added "tpm_" prefix for consistency sake. Changed cmd parameter as
>> > opaque. This enables to use separate command structures for TPM1
>> > and TPM2 commands in future. Loose coupling works fine here.
>> >
>> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> > Reviewed-by: Jasob Gunthorpe <jason.gunthorpe@obsidianresearch.com>
>> > Reviewed-by: Stephan Berger <stephan.berger@linux.vnet.ibm.com>
>> 
>> Not quite ... Stefan Berger <stefanb@linux.vnet.ibm.com>
>
>Oops. Peter, I guess you could fix those or? My apologies.
>
>>      Stefan
>
>/Jarkko
I'll fix this,
No problem.
Peter
-- 
Sent from my mobile.
