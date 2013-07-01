Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3GAW6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:58:21 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32260 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3GAW6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:58:20 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <201307020032.49963.PeterHuewe@gmx.de>
References: <1372714468-28120-1-git-send-email-dgdegra@tycho.nsa.gov> <201307020032.49963.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [tpmdd-devel] [PATCH v4] drivers/tpm: add xen tpmfront interface
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 01 Jul 2013 18:57:39 -0400
To: =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        tpmdd-devel@lists.sourceforge.net
CC: Daniel De Graaf <dgdegra@tycho.nsa.gov>, leosilva@linux.vnet.ibm.com,
        adlai@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, mail@srajiv.net, shpedoikal@gmail.com,
        tpmdd@sirrix.com
Message-ID: <38592a6a-62d1-48db-9219-641b610b4683@email.android.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Peter Hüwe" <PeterHuewe@gmx.de> wrote:

>Am Montag, 1. Juli 2013, 23:34:28 schrieb Daniel De Graaf:
>> This is a complete rewrite of the Xen TPM frontend driver, taking
>> advantage of a simplified frontend/backend interface and adding
>support
>> for cancellation and timeouts.  The backend for this driver is
>provided
>> by a vTPM stub domain using the interface in Xen 4.3.
>> 
>> Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
>> Acked-by: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
>> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Acked-by: Peter Huewe <peterhuewe@gmx.de>
>> Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
>> ---
>
>Reviewed, the remaining topics were addressed in this v4.
>Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
>
>
>From the TPM point of view I'd say it is fine.
>Acked-by: Peter Huewe <peterhuewe@gmx.de>
>
>Thanks!
>
>@Konrad: Can you take it through your tree?
>
>
>Thanks,
>Peter

Of course I will queue it up. I am not sure if it will be able to make it in 3.11 (merge window opened just now). 
-- 
Sent from my Android phone. Please excuse my brevity.
