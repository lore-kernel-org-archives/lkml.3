Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbaGWPlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:41:14 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:49986 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023AbaGWPlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:41:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140723131838.36359512@alan.etchedpixels.co.uk>
References: <1406010572-13217-1-git-send-email-xerofoify@gmail.com>
	<20140723131838.36359512@alan.etchedpixels.co.uk>
Date: Wed, 23 Jul 2014 11:41:11 -0400
Message-ID: <CAPDOMVgAsCaHV0RA1+Gz8H3-YpuuH4emcfSvTXe2hWNn8kVyQg@mail.gmail.com>
Subject: Re: [PATCH] s390: Fix me in dasd_eer.c
From: Nick Krause <xerofoify@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: wein@de.ibm.com, stefan.haberland@de.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 8:18 AM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Tue, 22 Jul 2014 02:29:32 -0400
> Nicholas Krause <xerofoify@gmail.com> wrote:
>
>> This patch changes return type to EMEDUIMTYPE in function, dasd_eer_enable
>> for when checking if the medium has no errors according to this function.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>
> What distributions have you tested this with and what configurations?

I have not tested this patch but based on the logical statements this
seems to be
correct.
Nick
