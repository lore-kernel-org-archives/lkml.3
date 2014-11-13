Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbaKMNkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:40:19 -0500
Received: from AUSXIPPC110.us.dell.com ([143.166.85.200]:37432 "EHLO
	ausxippc110.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978AbaKMNkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:40:17 -0500
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=X-LoopCount0:X-IronPort-AV:From:To:CC:Date:Subject:
   Thread-Topic:Thread-Index:Message-ID:References:
   In-Reply-To:Accept-Language:Content-Language:
   X-MS-Has-Attach:X-MS-TNEF-Correlator:acceptlanguage:
   Content-Type:Content-Transfer-Encoding:MIME-Version:
   Return-Path;
  b=IFuLWpCwlYRO1M4rZTn3uyyQICD9Fg05OMYV4zOZ2G2vZ2jG2UYxh/cQ
   PLViSi4Z5qvQ3kKabuYmNzGuObh9y3YsvQ0SuQOKXScnG4kE2pRr/FYD9
   f9VJxy5IRg6TgH6eOCFK/wOLltulb7qhSKgqkv38l20G9OS9q87hQ/FSG
   c=;
X-LoopCount0: from 10.175.216.250
X-IronPort-AV: E=Sophos;i="5.07,377,1413262800"; 
   d="scan'208";a="93462161"
From: <B_B_Singh@DELL.com>
To: <bp@suse.de>
CC: <stuart.w.hayes@gmail.com>, <hpa@zytor.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <matt.fleming@intel.com>, <jkosina@suse.cz>
Date: Thu, 13 Nov 2014 19:10:12 +0530
Subject: RE: [PATCH] x86: Configure NX support earlier in setup_arch
Thread-Topic: [PATCH] x86: Configure NX support earlier in setup_arch
Thread-Index: Ac//PiFjLqfI+RVZTrOadzHblVMaJgACFDGg
Message-ID: <8B2F6FFD0BD1E448853114367400A3730702007151@BLRX7MCDC203.AMER.DELL.COM>
References: <53B4B627.8060903@gmail.com> <53BC7210.1000305@gmail.com>
 <53BC72D8.4090705@zytor.com> <53BDE4BD.50605@gmail.com>
 <20140714172225.GE25120@pd.tnic>
 <8B2F6FFD0BD1E448853114367400A3730702007068@BLRX7MCDC203.AMER.DELL.COM>
 <20141113123045.GA14421@pd.tnic>
In-Reply-To: <20141113123045.GA14421@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sADDePIs024534


> -----Original Message-----
> From: Borislav Petkov [mailto:bp@suse.de]
> Sent: Thursday, November 13, 2014 6:01 PM
> To: Singh, B B
> Cc: stuart.w.hayes@gmail.com; hpa@zytor.com; tglx@linutronix.de;
> mingo@redhat.com; x86@kernel.org; linux-kernel@vger.kernel.org;
> matt.fleming@intel.com; Jiri Kosina
> Subject: Re: [PATCH] x86: Configure NX support earlier in setup_arch
> 
> On Thu, Nov 13, 2014 at 12:09:02PM +0530, B_B_Singh@DELL.com wrote:
> > I feel this can be a valid scenario where user wants to disable the
> > memory protection (NX flag disable) for his requirement, in that case
> > he will hit this issue. So request you to please revisit this patch.
> 
> First of all, please do not top-post. Here's why:
> 
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
> 

Sorry Boris, will make note on this & follow the same.

> Revisit this patch how? I'm not sure I understand...

I got an answer from Thomas, will check with BIOS team & come back. 

Thanks
Balaji Singh
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
