Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbaJ2Fgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:36:35 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:7328 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbaJ2Fge convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:36:34 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Joe Perches'" <joe@perches.com>
CC: "'Rob Herring'" <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 29 Oct 2014 13:36:30 +0800
Subject: RE: [RFC V4 1/3] add CONFIG_HAVE_ARCH_BITREVERSE to support rbit
 instruction
Thread-Topic: [RFC V4 1/3] add CONFIG_HAVE_ARCH_BITREVERSE to support rbit
 instruction
Thread-Index: Ac/zODnQ9lkV+OD2RNWCXe6MjhFHDgAAfPFw
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D18263@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
	 <1414392371.8884.2.camel@perches.com>
	 <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
	 <35FD53F367049845BC99AC72306C23D103E010D1825F@CNBJMBX05.corpusers.net>
 <1414560096.10912.18.camel@perches.com>
In-Reply-To: <1414560096.10912.18.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Joe Perches [mailto:joe@perches.com]
> > We also change byte_rev_table[] to be static, to make sure no drivers
> > can access it directly.
> 
> You break the build with this patch.
> 
> You can't do this until the users of the table are converted.
> 
> So far, they are not.
> 
> I submitted patches for these uses, but those patches are not yet applied.
> 
> Please make sure the dependencies for your patches are explicitly stated.
> 
Oh,  byte_rev_table[] must be extern,
Otherwise, bitrev8() can't access it ,
I will change it.
