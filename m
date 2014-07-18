Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbaGRDFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:05:15 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:61922 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbaGRDFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:05:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVjb_JxnGSTf5mW_RQ58h4-7fS6HywARpPV3XgWA33SybQ@mail.gmail.com>
References: <CAPDOMVjTxTNTfgPJMz6eNfabXuvtJ43YMpEeDEQ236EtF168Cg@mail.gmail.com>
	<20140717075204.GA15569@ravnborg.org>
	<CAPDOMVjb_JxnGSTf5mW_RQ58h4-7fS6HywARpPV3XgWA33SybQ@mail.gmail.com>
Date: Thu, 17 Jul 2014 23:05:12 -0400
Message-ID: <CAPDOMVj9GcoC26Sp6sOmwZf39mfOn=Wy87AnfzDguthcFOTXhg@mail.gmail.com>
Subject: Re: Sparc: Fix Mes in highmem.c
From: Nick Krause <xerofoify@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 1:38 PM, Nick Krause <xerofoify@gmail.com> wrote:
> On Thu, Jul 17, 2014 at 3:52 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> On Wed, Jul 16, 2014 at 10:25:30PM -0400, Nick Krause wrote:
>>> I am hitting three Fix mes in this file and am wondering as the
>>> maintainer how you would like
>>> to clean them up.
>>
>> They may be addressed if we one day decide to give the sparc32 highmem
>> support a big overhaul. Until then they are left as is.
>>
>>         Sam
>  Very well then I will just not touch it until we are going to
> overhaul the highmem  for
> sparc32.
> Cheers Nick
If you want I can fix the sparc32 highmem area with your help. I am new
to the kernel so a little help if needed would be great when doing this work
for you:).
Cheers Nick
