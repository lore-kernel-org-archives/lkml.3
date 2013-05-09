Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3EILsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 07:48:10 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50715 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab3EILsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 07:48:09 -0400
Message-ID: <518B8C45.7000504@linux.vnet.ibm.com>
Date: Thu, 09 May 2013 17:15:09 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Greg KH <gregkh@linuxfoundation.org>,
        balbi@ti.com, dyoung@redhat.com
Subject: Re: 3.9.0: WARNING: at drivers/base/core.c:575
References: <1732336275.8141054.1367911558572.JavaMail.root@redhat.com> <518B7B6A.1090407@linux.vnet.ibm.com> <1368096355.25488.178.camel@pasglop>
In-Reply-To: <1368096355.25488.178.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050911-7014-0000-0000-000002FF87C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 04:15 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2013-05-09 at 16:03 +0530, Srivatsa S. Bhat wrote:
>> Can you check if the patch posted here fixes it?
>>
>> http://marc.info/?l=linux-kernel&m=136791823608013&w=2
> 
> I believe I've already merged a patch for that unless I did something
> wrong ...
> 

Sorry, I hadn't checked your -next branch. Sorry for the noise!

Regards,
Srivatsa S. Bhat

